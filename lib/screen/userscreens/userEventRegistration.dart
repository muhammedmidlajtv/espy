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
        toolbarHeight: 0,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          /* crossAxisAlignment: CrossAxisAlignment.stretch, */
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    child: SizedBox(
                      height: 400,
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    /* boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.7), // Shadow color
                        spreadRadius: 0.1, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: Offset(0, 0), // Shadow position (x, y)
                        
                      ),
                    ], */
                  ),
                  child: Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    shadowColor: Color.fromARGB(255, 0, 0, 0),

                    color: Color(0xff658bb7),
                    child: SizedBox(
                      width: 250,
                      height: 480,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //CircleAvatar
                              const SizedBox(
                                height: 10,
                              ), //SizedBox
                              Text(
                                name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: 'Montserrat-Semibold',
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ), //Textstyle
                              ), //Text
                              const SizedBox(
                                height: 25,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Container(
                                            child: Image.asset(
                                                "assets/images/location_img.png"))),
                                  ),
                                  Text(
                                    venue,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Century-Gothic'),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Container(
                                            child: Image.asset(
                                                "assets/images/calender_icon.png"))),
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Century-Gothic'),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Container(
                                            child: Image.asset(
                                                "assets/images/tag.png"))),
                                  ),
                                  Text(
                                    type,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Century-Gothic'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ), //SizedBox
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Century-Gothic',
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
                                          fontFamily: 'Montserrat-Regular',
                                          fontSize: 20,
                                          color: const Color.fromARGB(
                                              255, 94, 39, 35),
                                          fontWeight: FontWeight.bold),
                                      "Speaker :  "),
                                  Text(
                                    speaker,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Century-Gothic'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-Regular',
                                          fontSize: 20,
                                          color: const Color.fromARGB(
                                              255, 94, 39, 35),
                                          fontWeight: FontWeight.bold),
                                      "Fee :  "),
                                  Text(
                                    fee,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Century-Gothic'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "For more info: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Century-Gothic'),
                                  ),
                                  Text(
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      " www.espy.com")
                                      
                                ],
                              ),
                              SizedBox(height: 50,),
                            ],
                          ),
                        ), //Column
                      ), //Padding
                    ), //SizedBox
                  ),
                ),
              ],
            ), //Size
            
            /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () async {
                      launchUrl(Uri.parse(reglink));

                      /*  if (await canLaunchUrl(Uri.parse(reglink))) {
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
                      } */
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
            ), */
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 150.0, // Adjust the width as needed
        height: 50.0, // Adjust the height as needed
        child: FloatingActionButton.extended(
          onPressed: () async {
            launchUrl(Uri.parse(reglink));
          },
          label: Text(
            "REGISTER",
            style: TextStyle(fontSize: 16.0,fontFamily: 'Montserrat-Regular'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
