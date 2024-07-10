import "dart:developer";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espy/main.dart';
import "package:espy/screen/authentication/auth_service.dart";
import 'package:espy/screen/organizerscreens/organizer.dart';
import 'package:espy/screen/signup/SignUp.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';

// final _textController = TextEditingController();
var isObscured = true;

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginScreenState();
}

// class _LoginScreenState extends State<Login>{
//   final _email = TextEditingController();
//   final _password = TextEditingController();
class _LoginScreenState extends State<Login> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      // resizeToAvoidBottomInset: false, // Disable resizing to avoid bottom overflow

      body: 
      Stack(
        fit: StackFit.expand,
        children: [
           Positioned.fill(
        child: Image.asset(
          "assets/images/sign_in.png", // Replace with your image path
          fit: BoxFit.fill,
        ),
      ),
      SingleChildScrollView(
            child: Column(
          children: [
            Container(
              height: 300,
              // child: DecoratedBox(
              //   decoration: BoxDecoration(
              //     // color: Colors.black,
              //     image: DecorationImage(
              //         image: AssetImage("assets/images/login_img.png"),
              //         fit: BoxFit.cover),
              //   ),
              //   child: Center(child: Text("")),
              // ),
            ),
            Form(
              key: _formKey,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
        
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          // filled: true,
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 166, 162, 162)),
                          hintText: "Enter your  Email",
                          labelText: "Email",
        
                          // fillColor: Colors.white70,
                        ),
                        controller: _email,
        
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
                        obscureText: isObscured,
        
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          suffixIcon: IconButton(
                            icon: isObscured
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                          ),
                          // filled: true,
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 166, 162, 162)),
                          hintText: "Enter your password",
                          labelText: "Password",
                          // fillColor: Colors.white70,
                        ),
                        controller: _password,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SocialLoginButton(
                        backgroundColor: Color(0xFF3E96D3),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            _login(context, _email.text, _password.text);
                            // _navigateToUserHomeUpScreen(context);
                          }
                        },
                        buttonType: SocialLoginButtonType.generalLogin,
                        borderRadius: 55,
                      ),
                      SizedBox(
                        height: 220,
                      ),
                      /* SizedBox(
                          height: 20,
                          width: 400,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 0.5,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Or    ",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: Container(
                                  height: 0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )), 
                       SizedBox(
                        height: 40,
                      ),
                      SocialLoginButton(
                        onPressed: () {
                          authenticateWithGoogle(context: context);
                        },
                        buttonType: SocialLoginButtonType.google,
                        borderRadius: 55,
                      ),
                      SizedBox(
                        height: 40,
                      ), */
                      SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Not a member ?   ",
                                style: TextStyle(color: Colors.white),
                              ),
                              GestureDetector(
                                child: Text(
                                  "Register Now ",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SignUp();
                                  }));
                                  /* Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => userEventRegistration()))); */
                                },
                              )
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ))

        ]
         ,
      ),
    );
  }

  void _navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUp()));
  }

  void _navigateToUserHomeUpScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => user_homeLogin()),
    );
  }

  void _navigateToOrganiserUpScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EventOrganizerApp()),
    );
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }
  //  _login(String email, String password) async {
  //   final _auth = AuthService();
  //   final user = await _auth.loginUserWithEmailAndPassword(email, password);

  //   if (user != null) {
  //     log("User Logged In");
  //     user_homeLogin();
  //   }
  // }
  void checkRole(String email) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("user_login")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final roleField =
            (querySnapshot.docs.first.data() as Map<String, dynamic>)['role'];
        final current_user =
            (querySnapshot.docs.first.data() as Map<String, dynamic>)['name'];

             current_user_name = current_user.toString();


        if (roleField != null) {
          final String role = roleField.toString().toLowerCase();
          log(role);
          if (role == "user") {
            final _sharedPrefs = await SharedPreferences.getInstance();
            await _sharedPrefs.setBool("userloggedin", true);
            _navigateToUserHomeUpScreen(context);
          } else {
            final _sharedPrefs = await SharedPreferences.getInstance();
            await _sharedPrefs.setBool("organizerloggedin", true);
            _navigateToOrganiserUpScreen(context);
          }
        } else {
          // Handle case when role field is null
          log("Role field is null for user with email: $email");
        }
      }
    } catch (error) {
      log("Error getting user data: $error");
    }
  }

  void _login(BuildContext context, String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await _auth.loginUserWithEmailAndPassword(email, password);
        if (user != null) {
          checkRole(email);
          log("User Logged In");
          current_logged_email = email;

          print(current_logged_email);

          //sharedpreferences

          //
        } else {
          _navigateToLoginScreen(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
    }
  }

  Future<void> authenticateWithGoogle({required BuildContext context}) async {
    try {
      final googleUser = await AuthService.signInWithGoogle();
      User user = googleUser.user!;

// Get the display name of the user
      String? username = user.displayName;
      String? email = user.email;

      log(username.toString());
      log(email.toString());

      log("User Logged In with google");
      _navigateToUserHomeUpScreen(context);

      //sharedpreferences

      final _sharedPrefs = await SharedPreferences.getInstance();
      await _sharedPrefs.setBool("userloggedin", true);

      //
    } on NoGoogleAccountChosenException {
      return;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }
}

class NoGoogleAccountChosenException implements Exception {
  const NoGoogleAccountChosenException();
}

  /* try {
    final googleuser=await AuthService.signInWithGoogle();
    
  } catch (e) {
    if (!context.mounted) return;
    const snackBar = SnackBar(
      content: Text('no google sign in '),
    );
  } */



//   @override
//   Widget build(BuildContext context) {
//     // Build a Form widget using the _formKey created above.
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           height: 300,
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               // color: Colors.black,
//               image: DecorationImage(
//                   image: AssetImage("assets/images/epsy_logo.png"),
//                   fit: BoxFit.cover),
//             ),
//             child: Center(child: Text("")),
//           ),
//         ),
//         Form(
//           key: _formKey,
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 SizedBox(
//                   height: 20,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                           color: Color.fromARGB(105, 255, 255, 255),
//                           width: 2.0),
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),

//                     // filled: true,
//                     hintStyle:
//                         TextStyle(color: Color.fromARGB(255, 151, 146, 146)),
//                     hintText: "Type in your text",
//                     // fillColor: Colors.white70,
//                   ),

//                   // The validator receives the text that the user has entered.
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter some text';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 TextFormField(
//                   style: const TextStyle(color: Colors.white),

//                   decoration: InputDecoration(

//                     fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     // filled: true,
//                     hintStyle:
//                         TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
//                     hintText: "Type in your text",
//                     // fillColor: Colors.white70,
//                   ),

//                   // The validator receives the text that the user has entered.
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter some text';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     // filled: true,
//                     hintStyle:
//                         TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
//                     hintText: "Type in your text",
//                     // fillColor: Colors.white70,
//                   ),

//                   // The validator receives the text that the user has entered.
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter some text';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     fillColor: Color.fromARGB(255, 0, 0, 0), filled: true,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     // filled: true,
//                     hintStyle:
//                         TextStyle(color: Color.fromARGB(255, 166, 162, 162)),
//                     hintText: "Type in your text",
//                     // fillColor: Colors.white70,
//                   ),

//                   // The validator receives the text that the user has entered.
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter some text';
//                     }
//                     return null;
//                   },
//                 ),
//                 // DropdownButton<String>(
//                 // items: <String>['A', 'B', 'C', 'D'].map((String value) {
//                 //   return DropdownMenuItem<String>(
//                 //     value: value,
//                 //     child: Text(value),
//                 //   );
//                 // }).toList(),
//                 // onChanged: (_) {},
//                 // ),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Validate returns true if the form is valid, or false otherwise.
//                       if (_formKey.currentState!.validate()) {
//                         // If the form is valid, display a snackbar. In the real world,
//                         // you'd often call a server or save the information in a database.
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Processing Data')),
//                         );
//                       }
//                     },
//                     child: const Text('Submit'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // DropdownMenuExample()
//       ],
//     );
//   }
// }
