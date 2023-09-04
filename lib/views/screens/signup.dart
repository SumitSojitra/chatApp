import 'package:chat_app/helper/auth_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;

  bool pass = true;
  bool pass1 = true;

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
                    "Sign Up",
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
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Wrong Password..";
                            }
                            return null;
                          },
                          obscureText: pass1,
                          controller: confirmController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.blueGrey.shade50,
                            hintStyle:
                                GoogleFonts.roboto(fontWeight: FontWeight.w400),
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              pass1 = !pass1;
                            });
                          },
                          icon: (pass1 == false)
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
                        confirmController.clear();

                        email = emailController.text;
                        password = passwordController.text;

                        AuthHelper.authHelper
                            .SignUp(email: email!, password: password!)
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
                        "Sign Up",
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
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://tse1.mm.bing.net/th?id=OIP.FnzI6eBMBS9n8VL7Wy39mAHaHa&pid=Api&P=0&h=180"),
                            )),
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
                        "Already have account? ",
                        style: GoogleFonts.roboto(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAndToNamed('/');
                        },
                        child: Text(
                          "Sign in",
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
