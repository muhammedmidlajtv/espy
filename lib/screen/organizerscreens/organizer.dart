import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espy/screen/organizerscreens/organizerform.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elon Musk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/organizer.png'),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("events").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  DateTime dateTime = DateTime.parse(snapshot.data!.docs[index]["date"].toString());
                  // Format the DateTime object to display the date
                  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            

                  return EventTile(
                    name: snapshot.data!.docs[index]["name"].toString(),
                    place: snapshot.data!.docs[index]["venue"].toString(),
                    time: snapshot.data!.docs[index]["time"].toString(),
                    date: formattedDate,
                    type: snapshot.data!.docs[index]["type"].toString(),
                    onDelete: () {
                      
                    },
                    onEdit: () {
                      
                    },
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.hasError.toString()}"),
              );
            } else {
              return Center(
                child: Text("No data found"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(), // Show loading indicator
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OrganiserForm();
          }));
          // Handle add new event action
        },
        child: Icon(Icons.add),
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
        color: Colors.white,
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
                ),
              ),
              Text(
                place,
                style: TextStyle(fontSize: 19.0),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 19.0),
              ),
              Text(
                date.toString(),
                style: TextStyle(fontSize: 19.0),
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
                    Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.green.shade900,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        onEdit();
                      },
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'Delete',
                      style: TextStyle(
                          color: Colors.red.shade900,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
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
