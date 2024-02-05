import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mywall/widgets/reuse_textfield.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController emailLogin = TextEditingController();

  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();

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
                    Text('Forget Password ? ',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(
                        height: 40, width: 30, child: Icon(Icons.lock))
                  ],
                ),
                Text('Enter the Email\nto recover your password ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ReuseTextField(
                    emailLabel: 'Enter Email',
                    emailLogin: emailLogin,
                    isObscure: false,
                    prefixIcon: const Icon(Icons.email),
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
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailLogin.text)
                          .then((value) {
                        Get.snackbar('Recovery Password',
                            'Recover Your Password Using Enter Email!',
                            margin: const EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            backgroundColor: Colors.green,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM);
                        Get.back();
                      }).onError((error, stackTrace) {
                        controller.stop();
                        Get.snackbar(
                            'Recovery Password Error', 'Something went wrong!',
                            margin: const EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            backgroundColor: Colors.red,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM);
                      });
                    },
                    child: Text(
                      'Send Recovery Password',
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already\'ve an account?',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 12)),
                      GestureDetector(
                        onTap: () {
                          // Navigator.of(context).pop();
                          Get.back();
                        },
                        child: Text(' Login',
                            style: GoogleFonts.poppins(
                                color: const Color(0xff00C1AA),
                                fontWeight: FontWeight.w800,
                                fontSize: 12)),
                      ),
                    ],
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
