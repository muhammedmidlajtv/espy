import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(FeedbackApp());
}

class FeedbackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Feedback Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          hintStyle: TextStyle(color: Colors.black45),
        ),
      ),
      home: FeedbackPage(),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String feedbackText = '';

  Future<String?> getCurrentUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }

  Future<String?> getCurrentUserName(String userEmail) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user_login')
        .where('email', isEqualTo: userEmail)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['name'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Feedback',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat-Semibold'),),
      ),
      body: Container(
        /* decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/organiser_dash_2.png'),
            fit: BoxFit.cover,
          ),
        ), */

        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff03052f)
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'We value your feedback !',
                  style: TextStyle(
                    
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter your feedback here',
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    setState(() {
                      feedbackText = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    backgroundColor: Colors.blue,
                    textStyle: TextStyle(fontSize: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    final userEmail = await getCurrentUserEmail();
                    if (userEmail != null && feedbackText.isNotEmpty) {
                      final userName = await getCurrentUserName(userEmail);
                      // Store feedback in Firestore
                      await FirebaseFirestore.instance.collection('feedback').add({
                        'userEmail': userEmail,
                        'userName': userName ?? 'Anonymous', // Default to 'Anonymous' if name not found
                        'feedbackText': feedbackText,
                        'timestamp': Timestamp.now(),
                      });

                      // Display success dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Feedback Submitted',style: TextStyle(fontFamily: 'Montserrat-Regular'),),
                            content: Text('Thank you for your feedback!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );

                      // Clear feedback text
                      setState(() {
                        feedbackText = '';
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please enter your feedback before submitting.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Submit Feedback',style: TextStyle(fontFamily: 'Montserrat-Regular'),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}