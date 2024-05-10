import 'package:flutter/material.dart';

class FeedbackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Feedback'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/organiser_dash_2.png'), // Path to your background image
              fit: BoxFit
                  .cover, // Adjust the image's size to cover the entire container
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your feedback here',
                    hintStyle: TextStyle(color: Colors.white), // Change hint text color to white
                  ),
                  onChanged: (value) {
                    setState(() {
                      feedbackText = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle submitting feedback
                    if (feedbackText.isNotEmpty) {
                      // For demonstration, just print the feedback
                      print('Feedback submitted: $feedbackText');
                      // You can add your logic to send feedback to a server or database here
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Feedback Submitted'),
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
                      // Clear the text field after submitting feedback
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
                  child: Text('Submit Feedback'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}