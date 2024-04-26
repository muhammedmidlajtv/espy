import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espy/screen/organizerscreens/registration.dart';
import 'package:file_picker/file_picker.dart';
import 'package:espy/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import DateFormat
import 'package:firebase_storage/firebase_storage.dart';

class OrganiserForm extends StatefulWidget {
  @override
  _OrganiserFormState createState() => _OrganiserFormState();
}

class _OrganiserFormState extends State<OrganiserForm> {
  // DateTime? selectedDate; // Variable to store selected date

  // Function to open date picker
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

  // List<Map<String, String>> _speakers = [];

  // String imageUrl = '';
  String FileName = "";

  String? _filePath;

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Text('BASIC DETAILS',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: eventNameController,
                  decoration: InputDecoration(labelText: 'Name of the Event'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name of the Event is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: organizerNameController,
                  decoration:
                      InputDecoration(labelText: 'Name of the Organizer'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name of the Organizer is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: eventTimeController,
                  decoration: InputDecoration(labelText: 'Time of the Event'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Time of the Event is required';
                    }
                    return null;
                  },
                ),
                // Text form field for date with calendar option
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
                
                // Dropdown for selecting event type
                TextFormField(
                  controller: eventTypeController,
                  decoration: InputDecoration(
                    labelText: 'Type of Event (e.g. Hackathon, Ideathon)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Type of Event is required';
                    }
                    return null;
                  },
                ),
                // Dropdown for selecting event mode
                DropdownButtonFormField<String>(
                  value: eventMode,
                  onChanged: (value) {
                    setState(() {
                      eventMode = value!;
                    });
                  },
                  items: ['Online', 'Offline']
                      .map<DropdownMenuItem<String>>((mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Mode of Event'),
                ),
                TextFormField(
                  controller: eventDescriptionController,
                  decoration: InputDecoration(
                      labelText: 'Brief Description of the Event'),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Brief Description of the Event is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: skillController,
                  decoration: InputDecoration(labelText: 'Skills Assessed'),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Skills Assessed is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Upload Poster of the Event',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Open file picker
                    // FilePickerResult? result =
                    //     await FilePicker.platform.pickFiles();

                    // if (result != null) {
                    //   setState(() {
                    //     _filePath = result.files.single.path;
                    //   });
                    // }

                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (file == null) return;

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('posters');

                    Reference referenceImageToUpload =
                        referenceDirImages.child('${file?.name}');

                    FileName = file.name;
                    try {
                      await referenceImageToUpload.putFile(File(file.path));

                      imageUrl = await referenceImageToUpload.getDownloadURL();
                      print(imageUrl);
                    } catch (error) {}
                    // referenceImageToUpload.putFile(File(file!.path));
                  },
                  child: Text('Choose a File'),
                ),
                Container(
                  child: Text(FileName),
                ),
                SizedBox(height: 10),
                if (_filePath != null)
                  Text(
                    'Selected File: $_filePath',
                    style: TextStyle(fontSize: 16),
                  ),
                SizedBox(height: 20),
                Text('SPEAKERS',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Column(
                  children: [
                    for (var speaker in speakers)
                      ListTile(
                        title: Text(
                            '${speaker['name']} - ${speaker['designation']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            setState(() {
                              speakers.remove(speaker);
                            });
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add a new speaker
                    showDialog(
                      context: context,
                      builder: (context) {
                        // TextEditingController _nameController =
                        //     TextEditingController();
                        // TextEditingController _designationController =
                        //     TextEditingController();
                        return AlertDialog(
                          title: Text('Add Speaker'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    labelText: 'Name of the Speaker'),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: designationController,
                                decoration:
                                    InputDecoration(labelText: 'Designation'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (nameController.text.isNotEmpty &&
                                    designationController.text.isNotEmpty) {
                                  setState(() {
                                    speakers.add({
                                      'name': nameController.text,
                                      'designation': designationController.text,
                                    });
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Add'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Speaker'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      // Validate the form
                      // if (_filePath != null) {
                      //   // Save and proceed to next page for registration details form
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) {
                      //     return RegistrationForm();
                      //   }));
                      // } else {
                      //   // Show error message if file is not uploaded
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //         content: Text(
                      //             'Please upload the poster of the event')),
                      //   );
                      // }
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("please upload poster")));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          //  return RegistrationForm();
                          return RegistrationDetailsPage();
                        }));
                      }
                    }
                  },
                  child: Text('Save and Proceed'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
