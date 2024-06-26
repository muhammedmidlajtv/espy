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
                      backgroundImage: AssetImage('assets/images/organizer.png'),
                    ),
                  ],
                ),
                body: Container(
                    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/organiser_dash_bg.png'), // Path to your background image
        fit: BoxFit.cover, // Adjust the image's size to cover the entire container
      ),
    ),
                  child: Column(
                    
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Upcoming Event Details',
                        style: TextStyle(
                          color: Color.fromARGB(255, 25, 117, 2),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      //code for Upcoming events
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("events")
                              .where("organiser_id",
                                  isEqualTo:
                                      currentLogged) // Filter events by user's email
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemBuilder: (context, index) {
                                    DateTime dateTime = DateTime.parse(snapshot
                                        .data!.docs[index]["date"]
                                        .toString());
                                    // Check if the event date is after today
                                    if (dateTime.isAfter(DateTime.now())) {
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy').format(dateTime);
                                
                                      return EventTile(
                                        name: snapshot.data!.docs[index]["name"]
                                            .toString(),
                                        place: snapshot.data!.docs[index]["venue"]
                                            .toString(),
                                        time: snapshot.data!.docs[index]["time"]
                                            .toString(),
                                        date: formattedDate,
                                        type: snapshot.data!.docs[index]["type"]
                                            .toString(),
                                        onDelete: () async {
                                          await FirebaseFirestore.instance
                                              .collection("events")
                                              .doc(snapshot.data!.docs[index].id)
                                              .delete();
                                        },
                                        onEdit: () {},
                                      );
                                    } else {
                                      // Return an empty container for events that are in the past
                                      return Container();
                                    }
                                  },
                                  itemCount: snapshot.data!.docs.length,
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("${snapshot.error.toString()}"),
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
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Past Event Details',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      //code for past events
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("events")
                              .where("organiser_id",
                                  isEqualTo:
                                      currentLogged) // Filter events by user's email
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemBuilder: (context, index) {
                                    DateTime dateTime = DateTime.parse(snapshot
                                        .data!.docs[index]["date"]
                                        .toString());
                                    // Check if the event date is before today
                                    if (dateTime.isBefore(DateTime.now())) {
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd').format(dateTime);
                                
                                      return EventTile1(
                                        name: snapshot.data!.docs[index]["name"]
                                            .toString(),
                                            
                                        place: snapshot.data!.docs[index]["venue"]
                                            .toString(),
                                        time: snapshot.data!.docs[index]["time"]
                                            .toString(),
                                        date: formattedDate,
                                        type: snapshot.data!.docs[index]["type"]
                                            .toString(),
                                        onDelete: () async {
                                          await FirebaseFirestore.instance
                                              .collection("events")
                                              .doc(snapshot.data!.docs[index].id)
                                              .delete();                                  
                                        },
                                        
                                        onEdit: () {},
                                      );
                                    } else {
                                      // Return an empty container for events that are in the future
                                      return Container();
                                    }
                                  },
                                  itemCount: snapshot.data!.docs.length,
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("${snapshot.error.toString()}"),
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
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          FloatingActionButton(
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
                                  // Shape of the container (circle for icon)
                                ),
                            padding: EdgeInsets.all(16), // Padding around the icon
                    
                              child: Icon(Icons.add,                                         // Color of the icon
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () async {
                              await auth.signout();
                              goToLogin(context);
                              final _sharedPrefs =
                                  await SharedPreferences.getInstance();
                              await _sharedPrefs.setBool("organizerloggedin", false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF3E96D3), // Background color
                                  borderRadius: BorderRadius.circular(15), // Rounded corners
                                ),
                            padding: EdgeInsets.all(16), // Padding around the icon
                    
                              
                              child: Icon(Icons.exit_to_app,)),
                          ),
                        ],
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
        color: Colors.white24,
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
                  fontSize: 25.0,
                  decoration: TextDecoration.underline,
                  color: Color.fromARGB(255, 255, 255, 255)
                ),
              ),
              Text(
                type,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.blue, // Customize the color if needed
                ),
              ),
              Text(
                place,
                style: TextStyle(fontSize: 19.0,color: Color.fromARGB(255, 204, 192, 192)
),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 19.0,color: Color.fromARGB(255, 204, 192, 192)
),
              ),
              Text(
                date.toString(),
                style: TextStyle(fontSize: 19.0,color: Color.fromARGB(255, 204, 192, 192))
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 50,),
              
              Container(
                child: Row(
                  children: [
                    // Text(
                    //   'Edit',
                    //   style: TextStyle(
                    //       color: Colors.green.shade900,
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w500),
                    // ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          String name1;
                          return EditEventScreen(eventName: name);
                        }));
                        onEdit();
                      },
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    // Text(
                    //   'Delete',
                    //   style: TextStyle(
                    //       color: Colors.red.shade900,
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w500),
                    // ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Color.fromARGB(255, 169, 35, 25),
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
        color: Color.fromARGB(255, 218, 126, 126),
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
                name.toLowerCase(),
                
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  decoration: TextDecoration.underline,
                  color: Color.fromARGB(255, 87, 84, 84)
                ),
              ),
              Text(
                place,
                style: TextStyle(fontSize: 19.0,color: Colors.white),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 19.0,color: Colors.white),
              ),
              Text(
                date.toString(),
                style: TextStyle(fontSize: 19.0,color: Colors.white),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.blue, // Customize the color if needed
                ),
              ),
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
