import 'package:espy/main.dart';
import 'package:espy/screen/Login.dart';
import 'package:espy/screen/introductionScreen.dart';
import 'package:espy/screen/SignUp.dart';
import 'package:espy/screen/introductionScreen.dart';
import 'package:espy/screen/profile.dart';
import 'package:espy/screen/user_homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    checkUserLoggedIn();
    _navigatetohome();

    
  }

  _onboardcheck() async {
    final onboardcount = await SharedPreferences.getInstance();
    final int? onBoardCount = onboardcount.getInt('onBoardCount');
    
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                onBoardCount != 0 ? IntroductionScreen() : Login()));
  }

   _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});

    _onboardcheck();
    // context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  Future<void> gotoLogin() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(

        // context, MaterialPageRoute(builder: (context) => Login()));
        context,
        MaterialPageRoute(builder: (context) => Login()));
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

  Future<void> checkUserLoggedIn() async {
    final _SharedPrefs = await SharedPreferences.getInstance();
    final _userLoggedIn = _SharedPrefs.getBool(SAVE_KEY_NAME);
    if (_userLoggedIn == null || _userLoggedIn == false) {
      gotoLogin();
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => user_homeLogin())));
    }
  }
}
