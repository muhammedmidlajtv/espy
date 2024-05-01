import "dart:developer";
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:espy/screen/authentication/auth_service.dart";
import 'package:espy/screen/login/Login.dart';
import 'package:espy/screen/splash.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

bool isObscured=true;

List<String> selected = [];

class SignUp extends StatelessWidget {
  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[850],
          body: Center(
              child: SingleChildScrollView(
            child: const MyCustomForm(),
          ))),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

//multiselect categories
class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({super.key, required this.items});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

final List<String> _selectedItems = [];

class _MultiSelectState extends State<MultiSelect> {
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Categories"),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        )
      ],
    );
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  List<String> _categories = [];

  void _selectCategories() async {
    final List<String> items = [
      'Hackathon',
      'Ideathon',
      'Article Writing',
      'Talk Session',
      'Workshop'
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
          items: items,
        );
      },
    );

    if (results != null) {
      setState(() {
        _categories = results;
      });
    }
  }

  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _selectedRole;
  Color _selectedTextColor = Colors.white;

  // final _who = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 45),
          child: Container(
            height: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                // color: Colors.black,
                image: DecorationImage(
                    image: AssetImage("assets/images/epsy_logo.png"),
                    fit: BoxFit.cover),
              ),
              child: Center(child: Text("")),
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(
                  //   height: 20,
                  // ),
                  TextFormField(
                    // controller : nameController,
                    style: const TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // filled: true,
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
                      hintText: "Enter your name",
                      labelText: "Names",
                      // fillColor: Colors.white70,
                    ),

                    // The validator receives the text that the user has entered.
                    controller: _name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // filled: true,
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
                      hintText: "Enter your Email",
                      labelText: "Email",
                      // fillColor: Colors.white70,
                    ),

                    // The validator receives the text that the user has entered.
                    controller: _email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    obscureText: isObscured,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // filled: true,
                      
                      suffixIcon: IconButton(icon: isObscured? Icon(Icons.visibility):Icon(Icons.visibility_off),onPressed:() {
                        setState(() {
                          isObscured=!isObscured;
                        });
                      },
                      ),
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
                      hintText: "Enter your password",
                      labelText: "Password",
                      // fillColor: Colors.white70,
                    ),

                    // The validator receives the text that the user has entered.
                    controller: _password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // filled: true,
                      
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
                      hintText: "confirm  your password",
                      labelText: "Confirm password",
                      // fillColor: Colors.white70,
                    ),

                    // The validator receives the text that the user has entered.
                    controller: _confirm,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 0, 0,
                          0), // Set the initial background color of the field to black
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
                      hintText: "Who are you?",
                      labelText: "Who are you",
                    ),
                    dropdownColor: Colors
                        .black, // Set the dropdown option background color to black
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                        _selectedTextColor = Colors.white;

                        if (_selectedRole == 'User') {
                          _selectCategories();
                        }
                      });
                    },
                    items: <String>['Organiser', 'User']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: _selectedTextColor),
                        ),
                      );
                    }).toList(),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an option';
                      }

                      return null;
                    },
                  ),
                  if (_selectedRole == 'User') ...[
                    const Divider(
                      height: 30,
                    ),
                    Wrap(
                      children: _selectedItems
                          .map((e) => Chip(
                                label: Text(e),
                              ))
                          .toList(),
                    ),
                  ],

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 106, 96, 93),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.0)),
                            minimumSize: Size(400, 46),
                          ),
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if(_password.text!=_confirm.text)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Password doesnt match')),
                              );
                            }
                            else if (_formKey.currentState!.validate()) {
                              await _signup(context);
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              //_navigateToLoginScreen(context);

                              /* ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              ); */
                            }

                            
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Have an account ?   ",
              style: TextStyle(color: Colors.white),
            ),
            GestureDetector(
              child: Text(
                "Sign In",
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Login();
                }));
                /* Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => userEventRegistration()))); */
              },
            )
          ]),
        ),
        SizedBox(
          height: 20,
        ),

        // DropdownMenuExample()
      ],
    );
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }

  _signup(BuildContext context) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          _email.text, _password.text);
      if (user != null) {
        log("User Created Successfully");
        CollectionReference collRef = FirebaseFirestore
                                .instance
                                .collection('user_login');
                            collRef.add({
                              'name': _name.text,
                              'email': _email.text,
                              'password1': _password.text,
                              'password2': _confirm.text,
                              'role': _selectedRole.toString(),
                              for (int i = 0;
                                  i < _selectedItems.length;
                                  i++) ...{
                                'preferences$i': _selectedItems[i],
                              },
                            });
        // Navigate to the login page after successful signup
        _navigateToLoginScreen(context);
      }
    } on FirebaseAuthException catch (e) {
      
        // Handle other exceptions
        log('Error occurred: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.message}')),
        );
      
    } catch (e) {
      // Handle other exceptions

      log('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
// class DropdownMenuExample extends StatefulWidget {
//   const DropdownMenuExample({super.key});

//   @override
//   State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
// }

// class _DropdownMenuExampleState extends State<DropdownMenuExample> {
//   String dropdownValue = list.first;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<String>(
//       initialSelection: list.first,
//       onSelected: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
//         return DropdownMenuEntry<String>(value: value, label: value);
//       }).toList(),
//     );
//   }
// }
