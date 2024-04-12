import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import 'package:flutter/services.dart' for TextInputFormatter

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
              RegistrationForm(),
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
  // Define form fields and their controllers
  TextEditingController venueController = TextEditingController();
  TextEditingController mapLinkController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController regLinkController = TextEditingController();
  String participationType = 'Individual';
  String participationFee = 'Free';
  int? participationAmount = 0; // Changed to nullable int
  int? minParticipants = 1;
  int? maxParticipants = 1;
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits
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
            items: ['Individual', 'Team'].map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(labelText: 'Participation Type'),
          ),
          if (participationType == 'Team') ...[
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits
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
              if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Form is valid, ready to publish')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all required fields')),
                );
              }
            },
            child: Text('Publish'),
          ),
        ],
      ),
    );
  }
}
