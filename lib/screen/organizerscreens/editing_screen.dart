import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espy/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final TextEditingController newVenue = TextEditingController();
final TextEditingController newDate = TextEditingController();
final TextEditingController newRegLink = TextEditingController();

class EditEventScreen extends StatefulWidget {
  final String eventName;

  const EditEventScreen({Key? key, required this.eventName}) : super(key: key);

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  // final String organizerEmail;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String eventname = widget.eventName;
    // String newName = "currentName";
    // String newVenue = "currentVenue";
    // String newDate = "currentDate";
    // String newRegLink = "currentRegLink";

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: newVenue,
                decoration: InputDecoration(labelText: 'Enter new venue'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Time of the Event is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: eventTimeController,
                decoration: InputDecoration(labelText: 'Time of the Event'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'required';
                  }
                  return null;
                },
              ),
              TextFormField(
                // controller : _eventDateController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  labelText: 'Date of the Event',
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context); // Open calendar to choose date
                },
                controller: TextEditingController(
                  text: selectedDate == null
                      ? ''
                      : DateFormat('yyyy-MM-dd').format(selectedDate!),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date of the Event is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: newRegLink,
                decoration: InputDecoration(labelText: 'new reg link'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ' required';
                  }
                  return null;
                },
              ),
              // Add fields for other event details like date and registration link
              ElevatedButton(
                onPressed: () async {
                  print(eventname);
                  // Update only the details of the event with the given organizer's email
                  final eventsRef =
                      FirebaseFirestore.instance.collection('events');
                  final eventQuery = await eventsRef
                      .where('name', isEqualTo:eventname)
                      .get();

                      if (eventQuery.docs.isNotEmpty) {
      final eventDoc = eventQuery.docs.first;
      
      Map<String, dynamic> updatedFields = {};

      // Update fields if corresponding text fields are not empty
      if (selectedDate != null) {
        updatedFields['date'] = selectedDate.toString();
      }
      if (newVenue.text.isNotEmpty) {
        updatedFields['venue'] = newVenue.text;
      }
      if (newRegLink.text.isNotEmpty) {
        updatedFields['reg_link'] = newRegLink.text;
      }
      if (eventTimeController.text.isNotEmpty) {
        updatedFields['time'] = eventTimeController.text;
      }

      // Update the document in Firestore
      await eventDoc.reference.update(updatedFields);
    }

                  // if (eventQuery.docs.isNotEmpty) {
                  //   final eventDoc = eventQuery.docs.first;

                  //   await eventDoc.reference.update({
                  //     'date': selectedDate.toString(),
                  //     'venue': newVenue.text,
                  //     'reg_link': newRegLink.text,
                  //     'time' : eventTimeController.text
                  //     // Update other fields as needed
                  //   });
                  // }

                  Navigator.pop(context);
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
