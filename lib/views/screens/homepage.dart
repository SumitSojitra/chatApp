import 'package:chat_app/views/globals/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/helper/firestore_helper.dart';

import '../../helper/auth_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // Get.snackbar("Chat App", "Sign In SuccessFull..",
    //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor: pur,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              CircleAvatar(
                radius: 50,
                foregroundImage: NetworkImage(
                    "${AuthHelper.authHelper.firebaseAuth.currentUser!.photoURL}"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${AuthHelper.authHelper.firebaseAuth.currentUser!.displayName}",
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Text(
                "${AuthHelper.authHelper.firebaseAuth.currentUser!.email}",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    "Log Out",
                    style:
                        GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setBool("isVisited", false);
                        AuthHelper.authHelper
                            .SignOut()
                            .then((value) => Get.offAndToNamed('/'));
                      },
                      icon: Icon(
                        Icons.login,
                        color: Colors.white,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        title: Text(
          "Members",
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: pur,
        leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CircleAvatar(
              foregroundImage: NetworkImage(
                  "${AuthHelper.authHelper.firebaseAuth.currentUser!.photoURL}"),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool("isVisited", false);
                AuthHelper.authHelper
                    .SignOut()
                    .then((value) => Get.offAndToNamed('/'));
              },
              icon: Icon(
                Icons.login,
                color: Colors.white,
              ))
        ],
      ),
      // backgroundColor: pur,
      body: StreamBuilder(
        stream: FireStoreHelper.fireStoreHelper.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? MyData = snapshot.data;
            List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                (MyData == null) ? [] : MyData.docs;

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: bg,
                    child: ListTile(
                      onTap: () async {
                        Get.toNamed('/chat', arguments: <String>[
                          AuthHelper.authHelper.firebaseAuth.currentUser!.uid,
                          data[index]['uid'],
                          data[index]['email'],
                          data[index]['photo'],
                          data[index]['name'],
                        ]);

                        allMessages = await FireStoreHelper.fireStoreHelper
                            .displayMessage(
                          uid1: AuthHelper
                              .authHelper.firebaseAuth.currentUser!.uid,
                          uid2: data[index]['uid'],
                        );
                      },
                      leading: CircleAvatar(
                        foregroundImage:
                            NetworkImage("${data[index]["photo"]}"),
                      ),
                      // subtitle: Text("${data[index]['uid']}"),
                      title: Text(
                        "${data[index]['name']}",
                        style: GoogleFonts.roboto(color: Colors.white),
                      ),
                    ),
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
