import "dart:developer";
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:espy/screen/authentication/auth_service.dart";
import 'package:espy/screen/login/Login.dart';
//import 'package:espy/screen/splash.dart';
//import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/services.dart';
import 'package:telephony/telephony.dart';
import 'package:email_otp/email_otp.dart';

bool isObscured=true;

List<String> selected = [];

class SignUp extends StatelessWidget {
  SignUp({super.key});

@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/signup_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: const MyCustomForm(),
            ),
          ),
        ),
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
      'Hackathon','Ideathon','Workshop','Talk Session'
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
  final Telephony telephony = Telephony.instance;

  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  //final  _emailController = TextEditingController();
  final  _otpController = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _selectedRole;
  Color _selectedTextColor = Colors.white;
  EmailOTP myauth = EmailOTP();

 

// handle after otp is submitted
//   void handleSubmit(BuildContext context) {
//     if (_formKey.currentState!.validate()) {
//       // Validate OTP against the OTP sent to the email
//       _auth.verifyOtpFromEmail(
//           _emailController.text, // Pass the email from the text controller
//           _otpController.text,
//           ).then((UserCredential? userCredential) {
//   if (userCredential != null) {
//     // OTP verification successful, navigate to login screen
//     Navigator.pop(context);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => Login()),
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Invalid OTP',
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// });
    

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
                fit: BoxFit.cover,
              ),
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
                    fillColor: Colors.white24,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // filled: true,
                    hintStyle:
                        TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                    hintText: "Enter your name",
                    labelText: "Names",
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))
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
                    fillColor: Colors.white24,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // filled: true,
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
                    hintText: "Enter your Email",
                    labelText: "Email",
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))

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
                      fillColor: Colors.white24, filled: true,
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
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))

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
                      fillColor: Colors.white24, filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // filled: true,
                      
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
                      hintText: "confirm  your password",
                      labelText: "Confirm password",
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))

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
                      fillColor: Colors.white24, // Set the initial background color of the field to black
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
                      hintText: "Who are you?",
                      labelText: "Who are you",
                     labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))

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
      
                const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2F8CAD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            minimumSize: const Size(400, 46),
                          ),
                          onPressed: () async {
                                        // Call the _signup method when the button is pressed
                          await _signup(context);
                          
                    
                          // CollectionReference collRef = FirebaseFirestore
                          //     .instance
                          //     .collection('user_login');
                          // collRef.add({
                          //   'name': _name.text,
                          //   'email': _email.text,
                          //   'password1': _password.text,
                          //   // 'password2': _confirm.text,
                          //   'role': _selectedRole.toString(),
                          //   for (int i = 0; i < _selectedItems.length; i++) ...{
                          //     'preferences$i': _selectedItems[i],
                          //   },
                          // });
                          if (_formKey1.currentState!.validate()) {
                            final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }




  void _navigateToLoginScreen(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

 _signup(BuildContext context) async {
  try {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Send OTP
      myauth.setConfig(
        appEmail: "espyproject24@gmail.com",
        appName: "ESPY",
        userEmail: _email.text,
        otpLength: 6,
        otpType: OTPType.digitsOnly,
      );
      if (await myauth.sendOTP() == true) {
        // OTP sent successfully, show dialog for entering OTP
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Enter OTP"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text("An OTP has been sent to your email."),
                    TextField(
                      controller: _otpController,
                      decoration: InputDecoration(labelText: "OTP"),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (await myauth.verifyOTP(otp: _otpController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("OTP is verified"),
                        ),
                      );
                     final userCredential = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
                      if (userCredential != null) {
                         CollectionReference collRef = FirebaseFirestore
                              .instance
                              .collection('user_login');
                          collRef.add({
                            'name': _name.text,
                            'email': _email.text,
                            'password1': _password.text,
                            // 'password2': _confirm.text,
                            'role': _selectedRole.toString(),
                            for (int i = 0; i < _selectedItems.length; i++) ...{
                              'preferences$i': _selectedItems[i],
                            },
                          });
                        
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                      }
                      // Navigate to login page after successful OTP verification
                      // Navigator.pop(context); // Close the OTP dialog
                      // _navigateToLoginScreen(context); // Navigate to login page
                    }else {
                      // Invalid OTP
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Invalid OTP. Please try again."),
                        ),
                      );
                    }
                  },
                  child: Text("Verify"),
                ),
              ],
            );
          },
        );
      } else {
        // Failed to send OTP
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Oops, OTP send failed"),
          ),
        );
      }
    }
  } catch (e) {
    log('Error occurred: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
 }
}
                    
//   _signup(BuildContext context) async {
//   try {
//     final userCredential = await _auth.createUserWithEmailAndPassword(
//         _email.text, _password.text);

//     log("User Created Successfully");
//     CollectionReference collRef = FirebaseFirestore
//         .instance
//         .collection('user_login');
//     collRef.add({
//       'name': _name.text,
//       'email': _email.text,
//       'password1': _password.text,
//       'password2': _confirm.text,
//       'role': _selectedRole.toString(),
//       for (int i = 0; i < _selectedItems.length; i++) ...{
//         'preferences$i': _selectedItems[i],
//       },
//     });
//     // Send email verification
//     await userCredential?.sendEmailVerification();
//     // Show dialog for entering OTP
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Enter OTP"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _otpController,
//                 decoration: InputDecoration(labelText: "OTP"),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () async {
//                 // Verify OTP
//                 try {
//                   await userCredential?.reload();
//                   if (userCredential?.emailVerified ?? false) {
//                     // User verified, navigate to login screen
//                     _navigateToLoginScreen(context);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Invalid OTP. Please try again."),
//                       ),
//                     );
//                   }
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("Error verifying OTP: $e"),
//                     ),
//                   );
//                 }
//               },
//               child: Text("Verify"),
//             ),
//           ],
//         );
//       },
//     );
//   } on FirebaseAuthException catch (e) {
//     // Handle FirebaseAuthException
//     log('Error occurred: ${e.message}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('${e.message}')),
//     );
//   } catch (e) 
//   {
//     log('Error occurred: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('An error occurred: $e')),
//     );
//   }
// }