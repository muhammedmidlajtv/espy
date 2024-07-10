// import 'dart:html';
//import "dart:developer";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espy/main.dart';
import 'package:espy/screen/crud_service.dart';
import 'package:espy/screen/feedback.dart';
import 'package:espy/screen/organizerscreens/organizer.dart';
import 'package:espy/screen/profile.dart';
import 'package:espy/screen/userscreens/userEventRegistration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:espy/screen/authentication/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:espy/screen/login/Login.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:espy/screen/notification_service.dart";

final _auth = FirebaseAuth.instance;

// Define temporary variables to store selected values
String? tempSelectedCategory;
String? tempSelectedDistrict;
String? tempSelectedUniversity;

List<dynamic> preferencesList = [];
Iterable<QueryDocumentSnapshot<Object?>> filteredEvents = [];
String selectedCategory = "";
String selectedDistrict = "";
/* String selectedUniversity = ""; */

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              '',
              style: TextStyle(
                  color: Color.fromRGBO(200, 53, 53, 1), fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/login_img.png'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfilePage();
              }))
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FeedbackApp();
              }))
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            // onTap: () => {Navigator.of(context).pop()},
            onTap: () async {
              try {
                String? email = FirebaseAuth.instance.currentUser?.email;
                if (email != null) {
                  // Query documents based on email
                  final QuerySnapshot querySnapshot = await FirebaseFirestore
                      .instance
                      .collection("user_tokens")
                      .where("email", isEqualTo: email)
                      .get();

                  // Iterate through documents and delete each one
                  querySnapshot.docs.forEach((doc) async {
                    await doc.reference.delete();
                  });

                  print('Documents deleted successfully');
                } else {
                  print('User is not logged in');
                }
              } catch (e) {
                print('Error deleting documents: $e');
              }

              await auth.signout();
              await GoogleSignIn().signOut();
              await CRUDService.deleteUserToken();
              goToLogin(context);

              //sharedprefereces
              final _sharedPrefs = await SharedPreferences.getInstance();
              await _sharedPrefs.setBool("userloggedin", false);
              //
            },
          ),
        ],
      ),
    );
  }
}

//range slider

//

class user_homeLogin extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  user_homeLogin({Key? key});

  //filter

  @override
  _user_homeLoginState createState() => _user_homeLoginState();
}

class _user_homeLoginState extends State<user_homeLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  // Variables for search functionality
  String _searchQuery = ''; // Initialize search query

  @override
  void initState() {
    PushNotifications.getDeviceToken();
    _initializePage();
    super.initState();
  }

  Future<void> _initializePage() async {
    // Call your function here
    await _getCurrentUser();
    // Once the function completes, update the state to stop loading
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Filter options
  List<String> categories = [
    'Hackathon','Ideathon','Workshop','Talk Session'
  ];
  List<String> districts = ['Kottayam', 'Kollam', 'Ernankulam'];
  List<String> universities = ['RIT', 'CET', 'MACE'];

  RangeValues _currentRangeValues = const RangeValues(20, 60);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _Email = ""; // Initialize user ID

  void resetFilters() {
    setState(() {
      // Reset selected values to initial values
      selectedCategory = "";
      selectedDistrict = "";
      /* selectedUniversity = ""; */
    });
  }

  Future<void> _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Get the user's email
      print("User is signed in with email: ${user.email}");
      // Now you can use `userEmail` as needed.
      // For example, you can store it in your `email` field.
      final _Email = user.email.toString();
      /* setState(() {
         // Assuming `email` is a variable in your state
      }); */
      await _fetchPreferredDomains(_Email);
      // Continue with other operations (e.g., fetching preferred domains).
    } else {
      print("No user is signed in.");
    }
  }

  Future<void> _fetchPreferredDomains(String _Email) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userEmail = user.email; // Get the user's email
        if (userEmail != null && userEmail.isNotEmpty) {
          final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection("user_login")
              .where("email", isEqualTo: userEmail)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            final firstDocumentData = (querySnapshot.docs.first.data()
                as Map<String, dynamic>)['preferences'];
            preferencesList =
                firstDocumentData != null ? List.from(firstDocumentData) : [];
            print('\n');
            print(preferencesList);
          } else {
            print("User document does not exist.");
          }
        } else {
          print("User email is null or empty.");
        }
      } else {
        print("No user is signed in.");
      }
    } catch (e) {
      print("Error fetching preferred domains: $e");
    }
  }

  void applyFilters() {
    // Filter the items based on user selections
    setState(() {
      // Apply category filter
      // filteredImage = filteredImage.where((item) => /* Check category */).toList();
      // filteredTitle = filteredTitle.where((item) => /* Check category */).toList();

      // Apply price filter
      // filteredImage = filteredImage.where((item) => /* Check price */).toList();
      // filteredTitle = filteredTitle.where((item) => /* Check price */).toList();

      // Apply district filter
      // filteredImage = filteredImage.where((item) => /* Check district */).toList();
      // filteredTitle = filteredTitle.where((item) => /* Check district */).toList();

      // Apply university filter
      // filteredImage = filteredImage.where((item) => /* Check university */).toList();
      // filteredTitle = filteredTitle.where((item) => /* Check university */).toList();
    });
  }

  //

  @override
  Widget build(BuildContext context) {
    AssetImage backgroundImage = AssetImage('assets/images/user_dashboard.png');
    AuthService _auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          ' ESPY',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.white,
      ),
      key: _scaffoldKey,

      backgroundColor: Colors.grey[850],
      drawer: NavDrawer(), // Integrate NavDrawer here

      // appBar: AppBar(
      //   title: Text('Your App Title'),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/user_dashboard.png',
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 50,
                        width: 360,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 29, 116, 183),
                                width: 0.0,
                              ),
                            ),
                            hintText: 'Search',
                            suffixIcon: GestureDetector(
                              child: Icon(
                                Icons.filter_list, // or Icons.filter_alt
                                size: 30, // Adjust size as needed
                                color: Colors.blue, // Adjust color as needed
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Filters",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-Semibold'),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            // Category filter
                                            DropdownButtonFormField<String>(
                                              value: categories.first,
                                              items: categories
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat-Regular'),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                // Handle category filter change
                                                // setState(() {
                                                // Update selected category
                                                // selectedCategory = value ?? '';
                                                tempSelectedCategory = value;

                                                // });
                                              },
                                            ),

                                            // Price range filter
                                            //     Column(
                                            //       mainAxisAlignment: MainAxisAlignment.start,
                                            //       children: [
                                            //         // Text("Price Range:"),
                                            //         // SizedBox(width: 10),
                                            //          RangeSlider(
                                            //         values: RangeValues(start, end),
                                            //         labels: RangeLabels(start.toString(), end.toString()),
                                            //         onChanged: (value) {
                                            //           setState(() {
                                            //             start = value.start;
                                            //             end = value.end;
                                            //           });
                                            //         },
                                            //         min: 10.0,
                                            //         max: 80.0,
                                            //       ),
                                            // //       Text(
                                            // // "Start: " +
                                            // //     start.toStringAsFixed(2) +
                                            // //     "\nEnd: " +
                                            // //     end.toStringAsFixed(2),
                                            // // style: const TextStyle(
                                            // //   fontSize: 32.0,
                                            // // ),
                                            // //  )

                                            //       ],
                                            //     ),

                                            // District filter
                                            DropdownButtonFormField<String>(
                                              value: districts.first,
                                              items:
                                                  districts.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat-Regular')),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                // Handle district filter change
                                                // setState(() {
                                                // Update selected category
                                                tempSelectedDistrict = value;
                                                // });
                                              },
                                            ),

                                            // University filter
                                            /* DropdownButtonFormField<String>(
                                              value: universities.first,
                                              items: universities
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                // Handle university filter change
                                                // setState(() {
                                                // Update selected category
                                                tempSelectedUniversity = value;
                                                // });
                                              },
                                            ), */
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // Apply filters
                                            // print(categories);
                                            //  setState(() {
                                            selectedCategory =
                                                tempSelectedCategory ??
                                                    selectedCategory;
                                            selectedDistrict =
                                                tempSelectedDistrict ??
                                                    selectedDistrict;
                                            /* selectedUniversity =
                                                tempSelectedUniversity ??
                                                    selectedUniversity; */
                                            // });
                                            print(
                                                'Selected Category: $selectedCategory');
                                            print(
                                                'Selected District: $selectedDistrict');
                                            /* print(
                                                'Selected University: $selectedUniversity'); */
                                            // Navigator.of(context).pop(); // Close the dialog

                                            applyFilters();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Apply"),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              resetFilters();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("clear"))
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          onChanged: (value) {
                            // Update search query when text changes
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator()); // Show a loading indicator while waiting for data
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final events = snapshot.data!.docs.where((doc) =>
                        preferencesList.contains(doc[
                            'type'])); // Filter events based on preferencesList

                    if (selectedCategory.isNotEmpty &&
                            selectedDistrict
                                .isNotEmpty /* &&
                        selectedUniversity.isNotEmpty */
                        ) {
                      print("hi");
                      filteredEvents = events.where((event) =>
                              event['name']
                                  .toLowerCase()
                                  .contains(_searchQuery) &&
                              event['type'] == selectedCategory &&
                              event['district'] ==
                                  selectedDistrict /* &&
                          event['venue'] == selectedUniversity */
                          );
                    } else {
                      print("hlo");

                      filteredEvents = events.where((event) =>
                          event['name'].toLowerCase().contains(_searchQuery));
                    }

                    // final filteredEvents = events.where((event) =>
                    //     // event['name'].toLowerCase().contains(_searchQuery));
                    //     // event['name'].toLowerCase().contains(_searchQuery) &&
                    //     // event['type'] == selectedCategory &&
                    //     // event['district'] == selectedDistrict &&
                    //     // event['venue'] == selectedUniversity);
                    //     event['name'].toLowerCase().contains(_searchQuery) &&
                    //     event['type'] == selectedCategory &&
                    //     event['district'] == selectedDistrict &&
                    //     event['venue'] == selectedUniversity);
                    print(selectedCategory);

                    print("fetched it ");
                    return ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                            events.elementAt(index)['date'].toString());
                        // Check if the event date is after today

                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(dateTime);

                        final name = filteredEvents.elementAt(
                            index)['name']; // Access event name from document

                        final venue = filteredEvents.elementAt(
                            index)['venue']; // Access event name from document
                        final date = formattedDate;
                        final type = filteredEvents.elementAt(
                            index)['type']; // Access event name from document
                        final description = filteredEvents.elementAt(index)[
                            'description']; // Access event name from document
                        final speaker = filteredEvents.elementAt(index)[
                            'speaker_name']; // Access event name from document
                        final fee = filteredEvents.elementAt(
                            index)['fee']; // Access event name from document
                        final reglink = filteredEvents.elementAt(index)[
                            'reg_link']; // Access event name from document
                        final posterlink = filteredEvents.elementAt(
                            index)['poster']; // Access event name from document

                        return EventTile(
                          name: name,
                          venue: venue,
                          date: date,
                          type: type,
                          description: description,
                          speaker: speaker,
                          fee: fee,
                          reglink: reglink,
                          posterlink: posterlink,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer(); // Open the NavDrawer
        },
        child: Icon(Icons.menu),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String image;
  final String title;

  const CardItem({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: Colors.yellow[50],
        elevation: 8.0,
        margin: EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Image.network(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        /* Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => userEventRegistration()))); */
      },
    );
  }
}

goToLogin(BuildContext context) => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );

class EventTile extends StatelessWidget {
  final String name;
  final String venue;
  final String date;
  final String type;
  final String description;
  final String speaker;
  final String fee;
  final String reglink;
  final String posterlink;

  const EventTile({
    Key? key,
    required this.name,
    required this.venue,
    required this.date,
    required this.type,
    required this.description,
    required this.speaker,
    required this.fee,
    required this.reglink,
    required this.posterlink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xff2f5982),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                posterlink,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Century-Gothic',
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return userEventRegistration(
                        name: name,
                        venue: venue,
                        date: date,
                        type: type,
                        description: description,
                        speaker: speaker,
                        fee: fee,
                        reglink: reglink,
                        posterlink: posterlink,
                      );
                    }));
                  },
                ),
                SizedBox(height: 8.0),
                Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat-Regular',
                    fontSize: 20.0,
                    color: Color.fromARGB(255, 214, 214, 214),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
