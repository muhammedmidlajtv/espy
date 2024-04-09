import 'package:espy/screen/Login.dart';
import 'package:espy/screen/SignUp.dart';
import 'package:espy/screen/profile.dart';
import 'package:espy/screen/user_homeScreen.dart';
import 'package:flutter/material.dart';

// import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        // context, MaterialPageRoute(builder: (context) => Login()));
          context, MaterialPageRoute(builder: (context) => Login()));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage("assets/images/epsy_logo.png"),
                fit: BoxFit.fitWidth),
          ),
          child: Center(child: Text("")),
        ),
      ),
    );
  }

  void initstate() {}
}
