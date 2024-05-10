import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espy/screen/authentication/auth_service.dart';
import 'package:espy/screen/organizerscreens/organizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import 'package:flutter/services.dart' for TextInputFormatter
import 'package:espy/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> sendNotification(String eventName, String eventDate, String eventType) async {
  try {
    // Retrieve tokens from the 'user_login' collection in Firestore
    // Retrieve tokens from the 'user_login' collection in Firestore
    final usersSnapshot = await FirebaseFirestore.instance.collection('user_login').where('preferences', arrayContains: eventType).get();


    // Extract tokens from the snapshot
    List<String> userEmails = usersSnapshot.docs.map((doc) => doc['email'] as String).toList();

    // Retrieve tokens corresponding to the filtered user emails from the 'user_tokens' collection
    final tokensSnapshot = await FirebaseFirestore.instance.collection('user_tokens').where('email', whereIn: userEmails).get();

    // Extract tokens from the snapshot
    final tokens = tokensSnapshot.docs.map((doc) => doc['token']).toList();

    // Define the notification payload
    final notification = {
      'notification': {
        'title': 'New Event Added!',
        'body': 'Event: $eventName, a $eventType on $eventDate.',
      },
      'registration_ids': tokens, // Send the notification to filtered tokens
    };
    // Send the notification to Firebase Cloud Messaging (FCM)
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAufEHjfY:APA91bEb1pbWV_nGBipcrD1VGK7pnzZduXLf-Da2I8_51pl-D9JTzomIL9ob-iJq5msHB-4MvwuOi74gJ5sT5FhgK09iLyEcg8bF4APJm0v4pMG9AQLSeU-4v0mqjTYffSOtiG4C0Duf', // Replace with your Firebase server key
      },
      body: jsonEncode(notification),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}

final auth = AuthService();

String current_email = "";

class RegistrationDetailsPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: auth.getCurrentUserEmail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Or any loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          current_email = snapshot.data ?? "";
          print("${current_email}");
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Registration Details',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REGISTRATION DETAILS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    RegistrationForm(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: venueController,
            decoration: InputDecoration(labelText: 'Venue *'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Venue of the Event is required';
              }
              return null;
            },
          ),
          DropdownButtonFormField<String>(
            value: participationFee,
            onChanged: (value) {
              setState(() {
                participationFee = value!;
              });
            },
            items: ['Free', 'Paid'].map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(labelText: 'Participation Fee'),
          ),
          if (participationFee == 'Paid') ...[
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Allow only digits
              onChanged: (value) {
                setState(() {
                  participationAmount = int.tryParse(value);
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Participation Amount *'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Participation Amount is required';
                }
                return null;
              },
            ),
          ],
          TextFormField(
            controller: mapLinkController,
            decoration: InputDecoration(labelText: 'Link to Google Map'),
          ),
          TextFormField(
            controller: districtController,
            decoration: InputDecoration(labelText: 'District *'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'District is required';
              }
              return null;
            },
          ),
          DropdownButtonFormField<String>(
            value: participationType,
            onChanged: (value) {
              setState(() {
                participationType = value!;
              });
            },
            items:
                ['Individual', 'Team'].map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(labelText: 'Participation Type'),
          ),
          if (participationType == 'Team') ...[
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Allow only digits
              onChanged: (value) {
                setState(() {
                  minParticipants = int.tryParse(value);
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Min Participats  *'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Min Participants is required';
                }
                return null;
              },
            ),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Allow only digits
              onChanged: (value) {
                setState(() {
                  maxParticipants = int.tryParse(value);
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Max Participats  *'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Max Participants is required';
                }
                return null;
              },
            ),
          ],
          TextFormField(
            controller: regLinkController,
            decoration: InputDecoration(labelText: 'Registration Link *'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Registration Link is required';
              }
              return null;
            },
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // print("/////////////////${current_logged_email}");
              
              if (_formKey.currentState != null &&
                  _formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Form is valid, ready to publish')));
                CollectionReference collRef =
                    FirebaseFirestore.instance.collection('events');
                collRef.add({
                  //controllers from events basic information page

                  'name': eventNameController.text,
                  'name_organiser': organizerNameController.text,
                  'time': eventTimeController.text,
                  'type': eventType.toString(),
                  'mode': eventMode.toString(),
                  'description': eventDescriptionController.text,
                  'date': selectedDate.toString(),
                  'speaker_desig': designationController.text,
                  'skill': skillController.text,
                  'speaker_name': nameController.text,
                  // 'speaker_name': speakers['designation'],

                  for (int i = 0; i < speakers.length; i++) ...{
                    'speaker_name_$i': speakers[i]['name'],
                    'speaker_desig_$i': speakers[i]['designation'],
                  },

                  'poster': imageUrl,

                  // controllers from registration page
                  'venue': venueController.text,
                  'map': mapLinkController.text,
                  'district': districtController.text,
                  // 'type': districtController.text,
                  'reg_link': regLinkController.text,
                  'participation_Type': participationType.toString(),
                  'participation_fee': participationFee.toString(),
                  'fee': participationAmount.toString(),
                  'minparticipants': minParticipants.toString(),
                  'maxparticipans': maxParticipants.toString(),
                  "organiser_id": current_email,
                });
                sendNotification(eventNameController.text, selectedDate.toString(),eventType.toString());
                
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EventOrganizerApp();
                }));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all required fields')),
                );
              }
              print(eventNameController.text);
            },
            child: Text('Publish'),
            
          ),
        ],
      ),
    );
  }
  
}
