import "dart:developer";
import "package:espy/screen/auth_service.dart";
import 'package:firebase_auth/firebase_auth.dart';



class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong");
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
      log("No user found for that email.");
    } else if (e.code == 'wrong-password') {
      log("Wrong password provided for that user.");
    } else {
      log("Something went wrong: ${e.message}");
    }
  } catch (e) {
    log("Unexpected error occurred: $e");
  }
  return null;
}
  //   } catch (e) {
  //     log("Something went wrong");
  //   }
  //   return null;
  // }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong");
    }
  }
}