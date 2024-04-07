import 'package:espy/screen/Login.dart';
import 'package:espy/screen/splash.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        body: const MyCustomForm(),
      ),
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

class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,45),
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
              padding: const EdgeInsets.fromLTRB(20,0,20,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(
                  //   height: 20,
                  // ),
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
                      hintText: "Enter your name",
                      // fillColor: Colors.white70,
                    ),

                    // The validator receives the text that the user has entered.
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
                      // fillColor: Colors.white70,
                    ),

                    // The validator receives the text that the user has entered.
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
                      hintText: "Enter your password",
                      // fillColor: Colors.white70,
                    ),

                    // The validator receives the text that the user has entered.
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
                      // fillColor: Colors.white70,
                    ),

                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
               
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,15,0),
                      child: Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 106, 96, 93),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0)),
                            minimumSize: Size(400, 46),
                          ),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              _navigateToLoginScreen(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data')),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // DropdownMenuExample()
      ],
    );
  }
}

void _navigateToLoginScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
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
