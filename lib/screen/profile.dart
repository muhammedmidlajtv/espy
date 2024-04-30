// import 'dart:html';

import 'package:espy/screen/signup/SignUp.dart';
import 'package:espy/screen/splash.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:flutter/material.dart';

bool _isHackathonPressed = false;
bool _isquiz = false;
bool _workshop = false;
bool _ideathon = false;
bool _talksession = false;

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      // resizeToAvoidBottomInset: false, // Disable resizing to avoid bottom overflow

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://pbs.twimg.com/media/EYVxlOSXsAExOpX.jpg'), // Replace with your image URL
            ),
            SizedBox(height: 20),
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isHackathonPressed = true;
                    });
                    // Your button action here
                  },
                  child: Text('Hackathon'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isHackathonPressed
                        ? Colors.blue
                        : Colors.grey, // Change colors as desired
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _workshop = true;
                    });
                    // Your button action here
                  },
                  child: Text('Workshop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _workshop
                        ? Colors.blue
                        : Colors.grey, // Change colors as desired
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _workshop = true;
                    });
                    // Your button action here
                  },
                  child: Text('Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isquiz
                        ? Colors.blue
                        : Colors.grey, // Change colors as desired
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // Action for idea pitching button
                //   },
                //   child: Text('Workshop'),
                // ),
                // Add more buttons as needed
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _ideathon = true;
                    });
                    // Your button action here
                  },
                  child: Text('Ideathon'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ideathon
                        ? Colors.blue
                        : Colors.grey, // Change colors as desired
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _talksession = true;
                    });
                    // Your button action here
                  },
                  child: Text('Talk sessions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _talksession
                        ? Colors.blue
                        : Colors.grey, // Change colors as desired
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // Action for idea pitching button
                //   },
                //   child: Text('Workshop'),
                // ),
                // Add more buttons as needed
              ],
            )
          ],
        ),
      ),
    );
  }
}
