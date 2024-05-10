import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDService {
// save fcm token to firstore
  static Future<void> deleteUserToken() async {
     String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user_token')
          .where("email", isEqualTo: email)
          .get();
      
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    }
    // String? email = FirebaseAuth.instance.currentUser?.email;
    // if (email != null) {
    //   await FirebaseFirestore.instance
    //       .collection('user_token')
    //       .where("email", isEqualTo: userEmail)
    //       .delete();
    // }
  }


  static Future saveUserToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> data = {
      "email": user!.email,
      "token": token,
    };
    try {
      await FirebaseFirestore.instance
          .collection("user_tokens")
          .doc(user.uid)
          .set(data);

      print("Document Added to ${user.uid}");
    } catch (e) {
      print("error in saving to firestore");
      print(e.toString());
    }
  }
}