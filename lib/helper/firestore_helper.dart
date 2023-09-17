import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_helper.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUsers({required Map<String, dynamic> data}) async {
    await firebaseFirestore
        .collection("users")
        .doc("${AuthHelper.authHelper.firebaseAuth.currentUser?.uid}")
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsers() {
    return firebaseFirestore
        .collection("users")
        .where("uid",
            isNotEqualTo: AuthHelper.authHelper.firebaseAuth.currentUser?.uid)
        .snapshots();
  }

  //Send message
  Future<void> sendMessage(
      {required String uid1, required String uid2, required String msg}) async {
    String user1 = uid1;
    String user2 = uid2;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection('chat').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
        await querySnapshot.docs;

    bool RoomAvilable = false;
    String fetchUser1 = "";
    String fetchUser2 = "";

    //Check Chat room already available or not
    for (QueryDocumentSnapshot<Map<String, dynamic>> element in allDocs) {
      String p1 = element.id.split("_")[0];
      String p2 = element.id.split("_")[1];

      if ((user1 == p1 || user2 == p1) && (user1 == p2 || user2 == p2)) {
        RoomAvilable = true;
        fetchUser1 = element.data()["users"][0];
        fetchUser2 = element.data()["users"][1];
      }
    }

    //if Chat room is not available
    if (RoomAvilable == false) {
      await firebaseFirestore.collection("chat").doc("${uid1}_${uid2}").set(
        {
          "users": [uid1, uid2],
        },
      );

      await firebaseFirestore
          .collection("chat")
          .doc("${uid1}_${uid2}")
          .collection("messages")
          .add(
        {
          "sentBy": uid1,
          "receiveBy": uid2,
          "msg": msg,
        },
      );
    } else {
      //if Chat room is available
      await firebaseFirestore
          .collection("chat")
          .doc("${fetchUser1}_${fetchUser2}")
          .collection("messages")
          .add({
        "sentBy": uid1,
        "receiveBy": uid2,
        "timestamp": FieldValue.serverTimestamp(),
        "msg": msg,
      });
    }
  }

//Display message

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> displayMessage(
      {required String uid1, required String uid2}) async {
    String user1 = uid1;
    String user2 = uid2;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection("chat").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
        await querySnapshot.docs;

    bool RoomAvailable = false;
    String fetchuser1 = "";
    String fetchuser2 = "";

    for (QueryDocumentSnapshot<Map<String, dynamic>> element in allDocs) {
      String p1 = element.id.split("_")[0];
      String p2 = element.id.split("_")[1];

      if ((user1 == p1 || user2 == p1) && user1 == p2 || user2 == p2) {
        RoomAvailable = true;
        fetchuser1 = element.data()["users"][0];
        fetchuser2 = element.data()["users"][1];
      }
    }
    if (RoomAvailable == false) {
      await firebaseFirestore.collection("chat").doc("${uid1}_${uid2}").set({
        "users": [uid1, uid2],
      });

      return firebaseFirestore
          .collection("chat")
          .doc("${uid1}_${uid2}")
          .collection("messages")
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection("chat")
          .doc("${fetchuser1}_${fetchuser2}")
          .collection("messages")
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  Future<void> deleteChat(
      {required String uid, required String uid1, required String uid2}) async {
    await firebaseFirestore
        .collection("chat")
        .doc("${uid1}_${uid2}")
        .collection("messages")
        .doc("${uid}")
        .delete();
  }
}
