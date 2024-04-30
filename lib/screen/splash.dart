import 'package:espy/main.dart';
import 'package:espy/screen/login/Login.dart';
import 'package:espy/screen/introscreens/introductionScreen.dart';
import 'package:espy/screen/organizerscreens/organizer.dart';
import 'package:espy/screen/signup/SignUp.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
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
    _navigatetohome();
    //checkLoggedIn();
  }

  _onboardcheck() async {
    final onboardcount = await SharedPreferences.getInstance();
    final int? onBoardCount = onboardcount.getInt('onBoardCount');

    if (mounted) {
      // Check if the widget is still mounted

      onBoardCount != 0
          ? (Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
              return IntroductionScreen();
            })))
          : checkLoggedIn();
      /* Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => onBoardCount != 0 ? IntroductionScreen() : checkLoggedIn()),
); */

      /* Navigator.push(context, MaterialPageRoute(builder: (context) {
        return onBoardCount != 0 ? IntroductionScreen() : Login();
      })); */
    }
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});

    // Check if the widget is still mounted
    _onboardcheck();
  }

  Future<void> gotoLogin() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    if (mounted) {
      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (context) => SignUp()),
        MaterialPageRoute(builder: (context) => Login()),
      );
      /* Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      })); */
    }
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

  Future<void> checkLoggedIn() async {
    final _SharedPrefs = await SharedPreferences.getInstance();
    final _userLoggedIn = _SharedPrefs.getBool("userloggedin");
    final _organizerLoggedIn = _SharedPrefs.getBool("organizerloggedin");
    if (_userLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => user_homeLogin()),
      );
    } else if (_organizerLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EventOrganizerApp()),
      );
    } else {
      gotoLogin();
    }
  }
}
