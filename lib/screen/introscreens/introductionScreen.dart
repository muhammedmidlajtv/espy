import 'package:espy/screen/login/Login.dart';
import 'package:espy/screen/introscreens/intropage1.dart';
import 'package:espy/screen/introscreens/intropage2.dart';
import 'package:espy/screen/introscreens/intropage3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

//check last page
bool onLastPage = false;

class _IntroductionScreenState extends State<IntroductionScreen> {
  //page controller
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
          ],
        ),

        //dot indicator
        Container(
            alignment: Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //skip
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      "    SKIP",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  onDotClicked: (index) => _controller.animateToPage(index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn),
                ),

                onLastPage
                    ? GestureDetector(
                        onTap: () async {
                          final onboardcount =
                              await SharedPreferences.getInstance();
                          await onboardcount.setInt('onBoardCount', 0);
                          Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => Login()),
);

                        },
                        child: Text(
                          "DONE    ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          "NEXT    ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
              ],
            )),
      ],
    ));
  }
}
