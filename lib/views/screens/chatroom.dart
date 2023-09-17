import 'dart:developer';

import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/views/globals/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  var menu;
  @override
  Widget build(BuildContext context) {
    List<String> data =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xff0f0417),
          title: Text(
            "${data[4]}",
            style: GoogleFonts.roboto(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg.jpg"),
                        fit: BoxFit.cover))),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                      flex: 10,
                      child: StreamBuilder(
                        stream: allMessages,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("${snapshot.error}"),
                            );
                          } else if (snapshot.hasData) {
                            QuerySnapshot<Map<String, dynamic>> snapData =
                                snapshot.data;

                            List<QueryDocumentSnapshot<Map<String, dynamic>>>?
                                chats = snapData.docs;

                            return (chats!.isEmpty)
                                ? Center(
                                    child: Text("No Messages yet.."),
                                  )
                                : ListView.builder(
                                    reverse: true,
                                    itemCount: chats.length,
                                    itemBuilder: (context, i) {
                                      return GestureDetector(
                                        onLongPress: () {
                                          // FireStoreHelper.fireStoreHelper.deleteChat(
                                          //     uid: chats[i].id,
                                          //     uid1: chats[i]['sentBy'],
                                          //     uid2: chats[i]['receiveBy']);
                                        },
                                        child: Row(
                                          mainAxisAlignment: (chats[i]
                                                      ['sentBy'] ==
                                                  AuthHelper
                                                      .authHelper
                                                      .firebaseAuth
                                                      .currentUser
                                                      ?.uid)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: (chats[i]
                                                          ['sentBy'] ==
                                                      AuthHelper
                                                          .authHelper
                                                          .firebaseAuth
                                                          .currentUser
                                                          ?.uid)
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    (chats[i]['sentBy'] ==
                                                            AuthHelper
                                                                .authHelper
                                                                .firebaseAuth
                                                                .currentUser
                                                                ?.uid)
                                                        ? Container()
                                                        : CircleAvatar(
                                                            foregroundImage:
                                                                NetworkImage(
                                                                    "${data[3]}"),
                                                          ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Chip(
                                                        backgroundColor: pur,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(30),
                                                          ),
                                                        ),
                                                        label: Text(
                                                          "${chats[i]['msg']}",
                                                          style: GoogleFonts
                                                              .robotoSlab(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                  ],
                                                ),
                                                Text(
                                                  "${chats[i]['timestamp'].toDate().toString().split(" ")[1].split(":")[0]}"
                                                  ":${chats[i]['timestamp'].toDate().toString().split(" ")[1].split(":")[1]}",
                                                  style: GoogleFonts.robotoSlab(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    });
                          }
                          return CircularProgressIndicator();
                        },
                      )),
                  Container(
                    height: 56,
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: messageController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              FireStoreHelper.fireStoreHelper.sendMessage(
                                  uid1: data[0],
                                  uid2: data[1],
                                  msg: messageController.text);
                              messageController.clear();
                            },
                            icon: Icon(
                              Icons.send_outlined,
                              color: Colors.white60,
                            ),
                          ),
                          filled: true,
                          fillColor: pur,
                          hintStyle: GoogleFonts.quicksand(
                              color: Colors.white60,
                              fontWeight: FontWeight.w600),
                          hintText: "Message...",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              )),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(width: 0))),
                    ),
                    // color: Colors.red,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
