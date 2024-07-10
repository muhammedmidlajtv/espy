// import 'dart:html';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espy/main.dart';
import 'package:espy/screen/authentication/auth_service.dart';
import 'package:espy/screen/signup/SignUp.dart';
import 'package:espy/screen/splash.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool _isHackathonPressed = false;
bool _isquiz = false;
bool _workshop = false;
bool _ideathon = false;
bool _talksession = false;

final auth = AuthService();

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // String current_logged = auth.getCurrentUserEmail().toString();

  String userName = "...";
  String userEmail = "...";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Method to fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      List<dynamic> preferencesList = [];

      // String current_logged = auth.getCurrentUserEmail().toString();
      String? currentLogged = await auth.getCurrentUserEmail();
      print(currentLogged);

      // print("////////////${currentLogged}");
      // Assuming you have the email address of the current user
      userEmail = currentLogged!; // Replace with the actual email address

      // Access Firestore collection reference
      CollectionReference collRef =
          FirebaseFirestore.instance.collection('user_login');

      // Query for the user document with the specified email address
      final QuerySnapshot querySnapshot =
          await collRef.where("email", isEqualTo: userEmail).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming there's only one document for each user)
        final DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Update state with user's name and email
        setState(() {
          userName = (userDoc.data() as Map<String, dynamic>)["name"] ?? "...";
          userEmail =
              (userDoc.data() as Map<String, dynamic>)["email"] ?? "...";
          print("username : $userName");

          _isHackathonPressed = false;
          _isquiz = false;
          _workshop = false;
          _ideathon = false;
          _talksession = false;
          final prefList = (querySnapshot.docs.first.data()
              as Map<String, dynamic>)['preferences'];
          print("${prefList}");
          preferencesList = prefList != null ? List.from(prefList) : [];
          print(preferencesList);
          for (var i = 0; i < preferencesList.length; i++) {
            if (preferencesList[i] == "Hackathon") {
              _isHackathonPressed = true;
            }
            if (preferencesList[i] == "Ideathon") {
              _ideathon = true;
            }
            if (preferencesList[i] == "Workshop") {
              _workshop = true;
            }
            if (preferencesList[i] == "Talk Session") {
              _talksession = true;
            }
            if (preferencesList[i] == "Quiz") {
              _isquiz = true;
            }
          }
        });
      } else {
        // Handle case where user with the specified email address is not found
        print("User not found with email: $userEmail");
      }
    } catch (e) {
      // Handle errors
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      // resizeToAvoidBottomInset: false, // Disable resizing to avoid bottom overflow

      body: Container(
        decoration: BoxDecoration(
          // Set background image
          image: DecorationImage(
            image: AssetImage(
                "assets/images/user_profile_bg.png"), // Change the path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                userName,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                userEmail,
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
                        _isHackathonPressed =
                            !_isHackathonPressed; // Toggle the boolean value
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
                        _workshop = !_workshop;
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
                  /* ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isquiz = !_isquiz;
                      });
                      // Your button action here 
                    },
                    child: Text('Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isquiz
                          ? Colors.blue
                          : Colors.grey, // Change colors as desired
                    ),
                  ), */
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
                        _ideathon = !_ideathon;
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
                        _talksession = !_talksession;
                      });
                      // Your button action here
                    },
                    child: Text('Talk Session'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _talksession
                          ? Colors.blue
                          : Colors.grey, // Change colors as desired
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: IconButton(
                      onPressed: () async {
                        // print(_isHackathonPressed.toString());
                        List<String> selectedPreferences = [];
                        if (_isHackathonPressed)
                          selectedPreferences.add("Hackathon");
                        if (_isquiz) selectedPreferences.add("Quiz");
                        if (_workshop) selectedPreferences.add("Workshop");
                        if (_ideathon) selectedPreferences.add("Ideathon");
                        if (_talksession)
                          selectedPreferences.add("Talk Session");

                        // Assuming you have the email address of the current user
                        // String userEmail = "john.doe@example.com"; // Replace with the actual email address

                        // Access Firestore collection reference
                        CollectionReference collRef =
                            FirebaseFirestore.instance.collection('user_login');

                        // Query for the user document with the specified email address
                        // print("////////////////////////{$current_logged_email}");
                        print(current_logged_email);
                        final QuerySnapshot querySnapshot =
                            await FirebaseFirestore.instance
                                .collection("user_login")
                                .where("email", isEqualTo: current_logged_email)
                                .get();
                        print(querySnapshot);
                        // Check if any documents match the query
                        if (querySnapshot.docs.isNotEmpty) {
                          // Loop through each document in the query results
                          for (DocumentSnapshot userDoc in querySnapshot.docs) {
                            // Update user preferences for the document with the specified email
                            await userDoc.reference.update({
                              'preferences': selectedPreferences,
                            });
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Preferences updated successfully')),
                          );

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return user_homeLogin();
                          }));
                        } else {
                          // Handle case where user with the specified email address is not found
                          print(
                              "User not found with email: $current_logged_email");
                        }

                        // Optionally, you can navigate to another screen or show a confirmation message.
                      },
                      icon: Image.asset("assets/images/tick.png"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
