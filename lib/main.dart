import 'package:chat_app/helper/shared.dart';
import 'package:chat_app/views/screens/chatroom.dart';
import 'package:chat_app/views/screens/homepage.dart';
import 'package:chat_app/views/screens/loginPage.dart';
import 'package:chat_app/views/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isSignIN = pref.getBool("isVisited") ?? false;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    GetMaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: "/",
          page: () => (isSignIN) ? HomePage() : LoginPage(),
        ),
        GetPage(
          name: "/signup",
          page: () => SignUp(),
        ),
        GetPage(
          name: "/home",
          page: () => HomePage(),
        ),
        GetPage(
          name: "/chat",
          page: () => ChatPage(),
        ),
      ],
    ),
  );
}
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool isSignIn = false;
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   getUserLoggedInStastus();
//   // }
//
//   // getUserLoggedInStastus() async {
//   //   await HelperFunction.helperFunction.getUserLoggedInStastus().then(
//   //     (value) {
//   //       if (value != null) {
//   //         isSignIn = value;
//   //       }
//   //     },
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
