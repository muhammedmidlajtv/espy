import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class userEventRegistration extends StatelessWidget {
  final String name;
  final String venue;
  final String date;
  final String type;
  final String description;
  final String speaker;
  final String fee;
  final String reglink;
  final String posterlink;

  const userEventRegistration({
    Key? key,
    required this.name,
    required this.venue,
    required this.date,
    required this.type,
    required this.description,
    required this.speaker,
    required this.fee,
    required this.reglink,
    required this.posterlink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "ESPY",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: SizedBox(
                  height: 200,
                  width: 90,
                  child: Image.network(
                    posterlink,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Text('Error loading image');
                    },
                  )),
            ),
            Card(
              // elevation: 50,
              shadowColor: Colors.black,
              color: Colors.greenAccent[100],
              child: SizedBox(
                width: 250,
                height: 480,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      
                      //CircleAvatar
                      const SizedBox(
                        height: 10,
                      ), //SizedBox
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green[900],
                          fontWeight: FontWeight.w500,
                        ), //Textstyle
                      ), //Text
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 15,
                                width: 15,
                                child: Container(
                                    child: Image.asset(
                                        "assets/images/location_img.png"))),
                          ),
                          Text(venue),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 15,
                                width: 15,
                                child: Container(
                                    child: Image.asset(
                                        "assets/images/calender_icon.png"))),
                          ),
                          Text(date),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 15,
                                width: 15,
                                child: Container(
                                    child: Image.asset(
                                        "assets/images/category.png"))),
                          ),
                          Text(type),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ), //SizedBox
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 124, 66, 66),
                        ), //Textstyle
                      ), //Text
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              "Speaker :"),
                          Text(speaker),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              "Fee :"),
                          Text(fee),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("For more info: "),
                          Text(
                              style: TextStyle(color: Colors.red),
                              " www.espy.com")
                        ],
                      ),
                    ],
                  ), //Column
                ), //Padding
              ), //SizedBox
            ), //Size
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(reglink))) {
                        launchUrl(Uri.parse(reglink));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text('Invalid Link'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ));
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: const [
                          Icon(Icons.touch_app),
                          Text(
                              style: TextStyle(
                                  color: Color.fromARGB(130, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                              'Register')
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
