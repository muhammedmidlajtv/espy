
import 'package:espy/screen/organizerscreens/organizerform.dart';
import 'package:flutter/material.dart';

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
        title: Text('Elon Musk',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/organizer.png'),
          ),
        ],
      ),
      body:
      
      
      Container(
        color: Colors.black,
        
        child: ListView(
          
          children: [
            ListTile(
              title: Text('UPCOMING EVENTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 33,color: Colors.white),),
            ),
            EventTile(
              name: 'Event 1',
              place: 'Location 1',
              time: '10:00 AM - 12:00 PM',
              date: '5 December 2024',
              type: 'Workshop',
              onDelete: () {
                // Handle delete action
              },
              onEdit: () {
                // Handle edit action
              },
            ),
            // Add more upcoming events here
            ListTile(
              title: Text('PAST EVENTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 33,color: Colors.white),),
            ),
            EventTile(
              name: 'Event 2',
              place: 'Location 2',
              time: '2:00 PM - 4:00 PM',
              date: '23 October 2024',
              type: 'Conference',
              onDelete: () {
                // Handle delete action
              },
              onEdit: () {
                // Handle edit action
              },
            ),
            // Add more past events here
          ],
        ),
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
                date,
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
                child: Row(children: [Text('Edit',style: TextStyle(color: Colors.green.shade900,fontSize: 18,fontWeight: FontWeight.w500),),IconButton(icon:Icon(Icons.edit),onPressed: (){} ,)],),
              ),
              Container(
                child: Row(children: [Text('Delete',style: TextStyle(color: Colors.red.shade900,fontSize: 18,fontWeight: FontWeight.w500),),IconButton(icon:Icon(Icons.delete),onPressed: (){} ,)],),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
