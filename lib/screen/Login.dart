import 'package:espy/screen/SignUp.dart';
import 'package:espy/screen/splash.dart';
import 'package:espy/screen/user_homeScreen.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
   Login({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          Container(
            height: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                // color: Colors.black,
                image: DecorationImage(
                    image: AssetImage("assets/images/login_img.png"),
                    fit: BoxFit.cover),
              ),
              child: Center(child: Text("")),
            ),
          ),
          Form(
            // key: _formKey,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                      hintText: "Enter your  Email",
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
                  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        _navigateToHomeUpScreen(context);

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Processing Data')),
                        // );
                      // }

                      // Validate returns true if the form is valid, or false otherwise.
                    },
                    child: const Text('Submit'),
                  ),
                )
                  // DropdownButton<String>(
                  // items: <String>['A', 'B', 'C', 'D'].map((String value) {
                  //   return DropdownMenuItem<String>(
                  //     value: value,
                  //     child: Text(value),
                  //   );
                  // }).toList(),
                  // onChanged: (_) {},
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // Validate returns true if the form is valid, or false otherwise.
                  //       // if (_formKey.currentState!.validate()) {
                  //       //   // If the form is valid, display a snackbar. In the real world,
                  //       //   // you'd often call a server or save the information in a database.
                  //       //   ScaffoldMessenger.of(context).showSnackBar(
                  //       //     const SnackBar(content: Text('Processing Data')),
                  //       //   );
                  //       // }
                  //     },
                  //     child: const Text('Submit'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 390,
                  height: 290,
                  // padding: new EdgeInsets.all(0.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                      ),
                      color: Color.fromARGB(255, 0, 0, 0),
                      elevation: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        // mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // ButtonBar(
                          // children: <Widget>[
                          IconButton(
                              onPressed: () {
                                _navigateToSignUpScreen(context);
                              },
                              iconSize: 50,
                              icon: Image.asset("assets/images/gmail_logo.png")),
                          // RaisedButton(
                          //   child: const Text('Pause'),
                          //   onPressed: () {/* ... */},
                          // ),
                          IconButton(
                              onPressed: () {},
                              iconSize: 40,
                              icon: Image.asset("assets/images/google_logo.png")),
                        ],
                        // ),
                        // ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


 void _navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
  }
  void _navigateToHomeUpScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => user_homeLogin()));
  }


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
