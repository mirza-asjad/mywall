// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywall/views/auth/forgetpassword_view.dart';
import 'package:mywall/views/auth/register_view.dart';
import 'package:mywall/views/home/home_view.dart';
import 'package:mywall/widgets/reuse_textfield.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailLogin = TextEditingController();

  final passwordLogin = TextEditingController();

  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();

  bool isSuffixIconChange = false;

  bool isObscureChange = true;

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
                    Text('Sign-in to the MyWall ',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(
                        height: 40,
                        width: 30,
                        child: Image.asset('assets/login.png'))
                  ],
                ),
                Text('Enter the Email & \nPassword to Login',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ReuseTextField(
                    emailLabel: 'Enter Email',
                    emailLogin: emailLogin,
                    isObscure: false,
                    prefixIcon: const Icon(Icons.alternate_email),
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
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                    //       const ForgetPasswordView()));
                    Get.to(() => const ForgetPasswordView());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text('Forget Password?',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, fontSize: 12)),
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
                      print(emailLogin.toString());
                      print(passwordLogin.toString());
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailLogin.text,
                              password: passwordLogin.text)
                          .then((value) {
                        Get.to(() =>const HomeView());
                      }).onError((error, stackTrace) {
                        controller.stop();
                        print(error);
                        print( emailLogin.text);
                        print(passwordLogin.text);
                        Get.snackbar('Login Error', 'Something went wrong!',
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
                      'Login',
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
                      Text('Don\'t have an account?',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 12)),
                      GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                          // const RegisterView()));
                          Get.to( ()=> const RegisterView());
                        },
                        child: Text(' Register Account',
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
