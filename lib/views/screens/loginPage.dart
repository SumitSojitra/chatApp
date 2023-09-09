import 'package:chat_app/helper/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool pass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "Sign In",
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter valid Email..";
                      }
                      return null;
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey.shade50,
                      hintStyle:
                          GoogleFonts.roboto(fontWeight: FontWeight.w400),
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter valid Password..";
                            }
                            return null;
                          },
                          obscureText: pass,
                          controller: passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.blueGrey.shade50,
                            hintStyle:
                                GoogleFonts.roboto(fontWeight: FontWeight.w400),
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              pass = !pass;
                            });
                          },
                          icon: (pass == false)
                              ? Icon(CupertinoIcons.eye)
                              : Icon(CupertinoIcons.eye_slash))
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        emailController.clear();
                        passwordController.clear();

                        AuthHelper.authHelper
                            .SignIn(
                                email: emailController.text,
                                password: passwordController.text)
                            .then(
                              (value) => Get.offAndToNamed('/home'),
                            );
                      }
                    },
                    child: Container(
                      // margin: EdgeInsets.all(16),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff7091F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "or",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          try {
                            User? res =
                                await AuthHelper.authHelper.SignInWithGoogle();

                            if (res != null) {
                              // Successfully signed in, navigate to the main page
                              Get.offAllNamed(
                                '/', // Replace with your main page route
                                arguments: res,
                              );
                            } else {
                              // Sign-in failed, display a Snackbar with an error message
                              Get.snackbar(
                                "Chat App",
                                "Sign In Failed...",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          } catch (error) {
                            // Handle exceptions that might occur during sign-in process
                            print("Error during Google Sign-In: $error");
                            Get.snackbar(
                              "Chat App",
                              "An error occurred. Please try again later.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://tse1.mm.bing.net/th?id=OIP.FnzI6eBMBS9n8VL7Wy39mAHaHa&pid=Api&P=0&h=180"),
                              )),
                        ),
                      ),
                      //Anonymous
                      GestureDetector(
                        onTap: () {
                          AuthHelper.authHelper.SignInAnonymously().then(
                                (value) => Get.offAndToNamed('/home'),
                              );
                        },
                        child: Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://tse4.mm.bing.net/th?id=OIP.hYAddS3gGM52qqmCreWEuAHaHa&pid=Api&P=0&h=180"),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.roboto(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAndToNamed('/signup');
                        },
                        child: Text(
                          "Sign up",
                          style: GoogleFonts.roboto(
                              color: Color(0xff7091F5),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
