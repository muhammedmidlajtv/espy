import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espy/main.dart';
import 'package:espy/screen/authentication/auth_service.dart';
import 'package:espy/screen/organizerscreens/editing_screen.dart';
import 'package:espy/screen/organizerscreens/organizerform.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final auth = AuthService();

String? currentLogged = "";

// Future<String?> getNameFromEmail(String email) async {
//   try {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('user_login')
//         .where('email', isEqualTo: email)
//         .limit(1)
//         .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       return querySnapshot.docs.first['name'];
//     } else {
//       return null; // User with the provided email not found
//     }
//   } catch (e) {
//     print('Error fetching name: $e');
//     return null;
//   }
// }

class EventOrganizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Event Organizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EventOrganizerPage(),
    );
  }
}

class EventOrganizerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      
      child: FutureBuilder<String?>(
        future: auth.getCurrentUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a loading indicator while fetching data
            return CircularProgressIndicator();
          } else {
            // Once data is fetched, check if there's any error
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              // If no error, get the current user's email
              String? currentLogged = snapshot.data;
              print(
                  "/////${currentLogged}"); // Now this should print the actual email

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'ESPY',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                  actions: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage:
                          AssetImage('assets/images/epsy_logo.png'),
                    ),
                  ],
                ),
                body: Container(

                  decoration: BoxDecoration(
                    color: Color(0xff03052f),
                    
                      /* image: DecorationImage(
      image: AssetImage('assets/images/organiser_dash_bg.png'), // Path to your background image
      fit: BoxFit.cover, // Adjust the image's size to cover the entire container
    ), */
    
                      ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("events")
                                    .where("organiser_id",
                                        isEqualTo: currentLogged)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    if (snapshot.hasData) {
                                      // Filter upcoming events
                                      final upcomingEvents =
                                          snapshot.data!.docs.where((doc) {
                                        DateTime dateTime = DateTime.parse(
                                            doc["date"].toString());
                                        return dateTime.isAfter(DateTime.now());
                                      }).toList();

                                      return Column(
                                        children: [
                                          if (upcomingEvents.isNotEmpty) ...[
                                            SizedBox(height: 5),
                                            Text(
                                              'UPCOMING EVENTS',
                                              style: TextStyle(
                                                color: Color.fromARGB(181, 88, 235, 51),
                                                fontWeight: FontWeight.bold,
                                                
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                DateTime dateTime =
                                                    DateTime.parse(
                                                        upcomingEvents[index]
                                                                ["date"]
                                                            .toString());
                                                String formattedDate =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(dateTime);
                                                return EventTile(
                                                  name: upcomingEvents[index]
                                                          ["name"]
                                                      .toString(),
                                                  place: upcomingEvents[index]
                                                          ["venue"]
                                                      .toString(),
                                                  time: upcomingEvents[index]
                                                          ["time"]
                                                      .toString(),
                                                  date: formattedDate,
                                                  type: upcomingEvents[index]
                                                          ["type"]
                                                      .toString(),
                                                  onDelete: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("events")
                                                        .doc(upcomingEvents[
                                                                index]
                                                            .id)
                                                        .delete();
                                                  },
                                                  onEdit: () {},
                                                );
                                              },
                                              itemCount: upcomingEvents.length,
                                            ),
                                          ],
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                            "${snapshot.error.toString()}"),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("No data found"),
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("events")
                                    .where("organiser_id",
                                        isEqualTo: currentLogged)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    if (snapshot.hasData) {
                                      // Filter past events
                                      final pastEvents =
                                          snapshot.data!.docs.where((doc) {
                                        DateTime dateTime = DateTime.parse(
                                            doc["date"].toString());
                                        return dateTime
                                            .isBefore(DateTime.now());
                                      }).toList();

                                      return Column(
                                        children: [
                                          if (pastEvents.isNotEmpty) ...[
                                            SizedBox(height: 5),
                                            Text(
                                              'PAST EVENTS',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                DateTime dateTime =
                                                    DateTime.parse(
                                                        pastEvents[index]
                                                                ["date"]
                                                            .toString());
                                                String formattedDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(dateTime);
                                                return EventTile1(
                                                  name: pastEvents[index]
                                                          ["name"]
                                                      .toString(),
                                                  place: pastEvents[index]
                                                          ["venue"]
                                                      .toString(),
                                                  time: pastEvents[index]
                                                          ["time"]
                                                      .toString(),
                                                  date: formattedDate,
                                                  type: pastEvents[index]
                                                          ["type"]
                                                      .toString(),
                                                  onDelete: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("events")
                                                        .doc(pastEvents[index]
                                                            .id)
                                                        .delete();
                                                  },
                                                  onEdit: () {},
                                                );
                                              },
                                              itemCount: pastEvents.length,
                                            ),
                                          ],
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                            "${snapshot.error.toString()}"),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("No data found"),
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return OrganiserForm();
                          }));
                          // Handle add new event action
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFF3E96D3), // Background color
                          ),
                          padding:
                              EdgeInsets.all(16), // Padding around the icon
                          child: Icon(Icons.add), // Color of the icon
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: FloatingActionButton(
                        onPressed: () async {
                          await auth.signout();
                          goToLogin(context);
                          final _sharedPrefs =
                              await SharedPreferences.getInstance();
                          await _sharedPrefs.setBool(
                              "organizerloggedin", false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF3E96D3), // Background color
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                          ),
                          padding:
                              EdgeInsets.all(16), // Padding around the icon
                          child: Icon(Icons.exit_to_app),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  final String name;
  final String place;
  final String time;
  final String date;
  final String type;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EventTile({
    Key? key,
    required this.name,
    required this.place,
    required this.time,
    required this.date,
    required this.type,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xff97d3cb),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat-Semibold',
                    fontSize: 25.0,
                    color: Color(0xff03052f)),
              ),
              
              Text(
                type,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blue, // Customize the color if needed
                  fontFamily: 'Century-Gothic'
                ),
              ),
              Text(
                place,
                style: TextStyle(fontSize: 19.0, color: Color(0xff03052f),fontFamily: 'Montserrat-Regular'),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 19.0, color: Color(0xff03052f),fontFamily: 'Montserrat-Regular'),
              ),
              Text(
                date.toString(),
                style: TextStyle(fontSize: 19.0, color: Color(0xff03052f),fontFamily: 'Montserrat-Regular'),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              SizedBox(height: 40,),
              Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        print("77777${name}");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditEventScreen(eventName: name);
                        }));
                        // onEdit();
                      },
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        onDelete();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EventTile1 extends StatelessWidget {
  final String name;
  final String place;
  final String time;
  final String date;
  final String type;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EventTile1({
    Key? key,
    required this.name,
    required this.place,
    required this.time,
    required this.date,
    required this.type,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xfffece8c),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat-Semibold',
                    fontSize: 25.0,
                    color: Color(0xff03052f)),
              ),
              
              Text(
                type,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blue, // Customize the color if needed
                  fontFamily: 'Century-Gothic'
                ),
              ),
              Text(
                place,
                style: TextStyle(fontSize: 19.0, color: Color(0xff03052f),fontFamily: 'Montserrat-Regular'),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 19.0, color: Color(0xff03052f),fontFamily: 'Montserrat-Regular'),
              ),
              Text(
                date.toString(),
                style: TextStyle(fontSize: 19.0, color: Color(0xff03052f),fontFamily: 'Montserrat-Regular'),
              ),
            ],
          ),
          /* Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              SizedBox(height: 40,),
              Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        print("77777${name}");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditEventScreen(eventName: name);
                        }));
                        // onEdit();
                      },
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        onDelete();
                      },
                    )
                  ],
                ),
              ),
            ],
          ), */
        ],
      ),
    );
  }
}
