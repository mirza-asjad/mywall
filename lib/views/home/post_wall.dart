import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mywall/views/home/home_view.dart';
import 'package:mywall/widgets/reuse_textfield.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MyPostView extends StatefulWidget {
  const MyPostView({super.key});

  @override
  State<MyPostView> createState() => _MyPostViewState();
}

class _MyPostViewState extends State<MyPostView> {
  final TextEditingController emailLogin = TextEditingController();

  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();

  String currentuserEmail = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    final double buttonwidth = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff000221),
        title: Text('MyWall',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              // Navigator.of(context).pop();
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Post',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    // const SizedBox(
                    //     height: 40, width: 30, child: Icon(Icons.))
                  ],
                ),
                Text('Share the post with others',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ReuseTextField(
                    emailLabel: 'Post....',
                    emailLogin: emailLogin,
                    isObscure: false,
                    prefixIcon: const Icon(Icons.post_add),
                    suffixIcon: false,
                    onSuffixIconChange: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: RoundedLoadingButton(
                    width: buttonwidth * 0.8,
                    color: const Color(0xff00C1AA),
                    controller: controller,
                    animateOnTap: true,
                    errorColor: Colors.red,
                    failedIcon: Icons.error,
                    onPressed: () async {
                      controller.start();
                      //POSTING
                      if (emailLogin.text.isNotEmpty) {
                       await FirebaseFirestore.instance
                            .collection('User Posts')
                            .add({
                          'UserEmail': currentuserEmail,
                          'Message': emailLogin.text,
                          'TimeStamp': Timestamp.now(),
                          'Likes' : [],
                        }).then((value) {
                          controller.stop();
                          Get.snackbar('Post', 'Successfully Posted',
                              margin: const EdgeInsets.only(
                                bottom: 10,
                                left: 10,
                                right: 10,
                              ),
                              backgroundColor: Colors.green,
                              borderRadius: 12,
                              snackPosition: SnackPosition.BOTTOM);

                          setState(() {
                            emailLogin.clear();
                          });

                          Get.to(() => const HomeView());
                        }).onError((error, stackTrace) {
                          controller.stop();
                          Get.snackbar('Post', 'Posted Unable to Posted',
                              margin: const EdgeInsets.only(
                                bottom: 10,
                                left: 10,
                                right: 10,
                              ),
                              backgroundColor: Colors.red,
                              borderRadius: 12,
                              snackPosition: SnackPosition.BOTTOM);
                        });
                      }
                    },
                    child: Text(
                      'Post',
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
