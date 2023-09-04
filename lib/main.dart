import 'package:chat_app/views/screens/homepage.dart';
import 'package:chat_app/views/screens/loginPage.dart';
import 'package:chat_app/views/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(GetMaterialApp(
    theme: ThemeData(useMaterial3: true),
    debugShowCheckedModeBanner: false,
    getPages: [
      GetPage(
        name: "/",
        page: () => LoginPage(),
      ),
      GetPage(
        name: "/signup",
        page: () => SignUp(),
      ),
      GetPage(
        name: "/home",
        page: () => HomePage(),
      ),
    ],
  ));
}
