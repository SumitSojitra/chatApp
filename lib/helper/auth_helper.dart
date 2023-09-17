import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/views/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  AuthHelper._();

  static AuthHelper authHelper = AuthHelper._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> SignInAnonymously() async {
    UserCredential userCredential = await firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  Future<User?> SignUp(
      {required String email, required String password}) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<Map<String, dynamic>> SignIn(
      {required String email, required String password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      FireStoreHelper.fireStoreHelper.addUsers(data: {
        "email": userCredential.user?.email,
        "name": userCredential.user?.displayName,
        "uid": userCredential.user?.uid,
        "photo": userCredential.user?.photoURL,
      });
      res['user'] = userCredential.user;
    } on FirebaseAuthException catch (e) {
      res['error'] = e.code;
    }
    return res;
  }

  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> SignInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);

    User? user = userCredential.user;
    FireStoreHelper.fireStoreHelper.addUsers(data: {
      "email": user?.email,
      "name": user?.displayName,
      "uid": user?.uid,
      "photo": user?.photoURL,
    });
    return user;
  }

  Future<void> SignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
