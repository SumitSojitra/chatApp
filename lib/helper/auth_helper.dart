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

  Future<User?> SignIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
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
    return user;
  }

  void SignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
