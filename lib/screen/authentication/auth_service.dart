import "dart:developer" as dev;
import 'dart:math' as math;
import 'package:espy/screen/login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:email_otp/email_otp.dart';


class AuthService {
  final _auth = FirebaseAuth.instance;
    EmailOTP myauth = EmailOTP();

  // static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // static String verifyId = "";

   Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          print(email);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      dev.log("Firebase Auth Exception: ${e.message}");
      throw e;
    } catch (e) {
      dev.log("Unexpected error occurred: $e");
    }
    return null;
  }


 
  

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        dev.log("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        dev.log("Wrong password provided for that user.");
      } else {
        dev.log("Something went wrong: ${e.message}");
      }
    } catch (e) {
      dev.log("Unexpected error occurred: $e");
    }
    return null;
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw const NoGoogleAccountChosenException();
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      dev.log("Something went wrong");
    }
  }
 

}
