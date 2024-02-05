// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywall/views/home/home_view.dart';
import 'package:mywall/widgets/reuse_textfield.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController emailLogin = TextEditingController();

  final TextEditingController passwordLogin = TextEditingController();
  final TextEditingController repasswordLogin = TextEditingController();

  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();

  bool isSuffixIconChange = false;

  bool isObscureChange = true;

  bool reisSuffixIconChange = false;

  bool reisObscureChange = true;

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
                    Text('Sign-up to the MyWall ',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(
                        height: 40,
                        width: 30,
                        child: Image.asset('assets/login.png'))
                  ],
                ),
                Text('Enter the Email & \nPassword to Join',
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
                  padding: const EdgeInsets.only(top: 20),
                  child: ReuseTextField(
                    emailLabel: 'Enter Passowrd',
                    emailLogin: passwordLogin,
                    isObscure: isObscureChange,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: true,
                    onSuffixIconChange: isSuffixIconChange,
                    isSuffixChange: () {
                      setState(() {
                        isObscureChange = !isObscureChange;
                        isSuffixIconChange = !isSuffixIconChange;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ReuseTextField(
                    emailLabel: 'Confirm Passowrd',
                    emailLogin: repasswordLogin,
                    isObscure: reisObscureChange,
                    prefixIcon: const Icon(Icons.lock_reset),
                    suffixIcon: true,
                    onSuffixIconChange: reisSuffixIconChange,
                    isSuffixChange: () {
                      setState(() {
                        reisObscureChange = !reisObscureChange;
                        reisSuffixIconChange = !reisSuffixIconChange;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text('Agree upon the term and conditions.',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, fontSize: 12)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: RoundedLoadingButton(
                    width: buttonwidth * 0.8,
                    color: const Color(0xff00C1AA),
                    controller: controller,
                    animateOnTap: true,
                    errorColor: Colors.red,
                    failedIcon: Icons.error,
                    onPressed: () async {
                      controller.start();
                      if (passwordLogin.text == repasswordLogin.text) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: emailLogin.text,
                                  password: passwordLogin.text);
                  
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(userCredential.user!.email)
                              .set(
                            {
                              'uid' : userCredential.user!.uid,
                              'email' :  userCredential.user!.email,
                              'username': emailLogin.text.split('@')[0],
                              'bio': 'EMPTY BIO', //HARD CODED
                            },
                          );
                  
                          // Authentication and user data storage successful, navigate to HomeView
                          Get.to(() => const HomeView());
                        } catch (error) {
                          controller.stop();
                          print(error);
                          Get.snackbar(
                            'SignUp Error',
                            'Something went wrong!',
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            backgroundColor: Colors.red,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      } else {
                        controller.stop();
                        Get.snackbar(
                          'SignUp Error',
                          'Password is not matched!',
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          backgroundColor: Colors.red,
                          borderRadius: 12,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Text(
                      'SignUp',
                      style:
                          GoogleFonts.poppins(fontSize: 15, color: Colors.white),
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
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                          // const LoginView()));
                          // Get.to(const LoginView());
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
