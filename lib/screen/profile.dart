// import 'dart:html';

import 'package:espy/screen/signup/SignUp.dart';
import 'package:espy/screen/splash.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      // resizeToAvoidBottomInset: false, // Disable resizing to avoid bottom overflow

      body: Column(
        
        children: [
                      Align(
                         alignment: Alignment.center,
                        child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                        "https://img.freepik.com/premium-vector/young-smiling-man-avatar-man-with-brown-beard-mustache-hair-wearing-yellow-sweater-sweatshirt-3d-vector-people-character-illustration-cartoon-minimal-style_365941-860.jpg"),
                                  radius: 1500,
                                ),
                      ),
                  
        ],
      ),
    );
  }
}
