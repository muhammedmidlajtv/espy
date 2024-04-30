import "dart:developer";
import 'package:espy/screen/login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  // static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // static String verifyId = "";

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
   // try {
      
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;


    /* } catch (e) {
      log("Something went wrong");
      return ;
    }
    return null; */
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
  // static Future sentOtp({
  //   required String phone,
  //   required Function errorStep,
  //   required Function nextStep,
  // }) async {
  //   await _firebaseAuth
  //       .verifyPhoneNumber(
  //     timeout: const Duration(seconds: 30),
  //     phoneNumber: "+91$phone",
  //     verificationCompleted: (phoneAuthCredential) async {
  //       return;
  //     },
  //     verificationFailed: (error) async {
  //       return;
  //     },
  //     codeSent: (verificationId, forceResendingToken) async {
  //       verifyId = verificationId;
  //       nextStep();
  //     },
  //     codeAutoRetrievalTimeout: (verificationId) async {
  //       return;
  //     },
  //   )
  //       .onError((error, stackTrace) {
  //     errorStep();
  //   });
  // }

  // // verify the otp code and login
  // static Future loginWithOtp({required String otp}) async {
  //   final cred =
  //       PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

  //   try {
  //     final user = await _firebaseAuth.signInWithCredential(cred);
  //     if (user.user != null) {
  //       return "Success";
  //     } else {
  //       return "Error in Otp login";
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     return e.message.toString();
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

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
      log("Something went wrong");
    }
  }
//   Future<bool> isLoggedIn() async {
//   // Ensure that FirebaseAuth instance is initialized.
//   FirebaseAuth auth = FirebaseAuth.instance;

//   // Check if the current user is not null.
//   var user = auth.currentUser;
  
//   // Return true if the user is not null, indicating that the user is logged in.
//   return user != null;
// }
}
