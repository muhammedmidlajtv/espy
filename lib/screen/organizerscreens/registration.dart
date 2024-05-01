import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import 'package:flutter/services.dart' for TextInputFormatter
import 'package:espy/main.dart';

class RegistrationDetailsPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
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
              RegistrationForm(
            
                  ),
            ],
          ),
        ),
      ),
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
                  'date' : selectedDate.toString(),
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
                  'maxparticipans': maxParticipants.toString()

                 
                }
                );
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
