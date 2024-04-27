// import 'dart:html';
//import "dart:developer";
import 'package:espy/main.dart';
import 'package:espy/screen/organizerscreens/organizer.dart';
import 'package:espy/screen/userscreens/userEventRegistration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:espy/screen/authentication/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:espy/screen/login/Login.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
List<String> image = [
  'https://t3.ftcdn.net/jpg/03/01/13/20/360_F_301132090_LKoSp3l3cXlCo78zaAe2M9LI2z5yznvB.jpg',
  'https://hbr.org/resources/images/article_assets/2014/10/25Sep03_Elsbach_how-to-pitch-a-brilliant-idea1.jpg',
  'https://www.nicmar.ac.in/uploads/ideathon-2023-header.png',
  'https://fortune.com/img-assets/wp-content/uploads/2016/05/unnamed.jpg'
];
List<String> title = ['Hackathon', 'Idea Pitching', ' Ideathon', 'CFT'];

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
              'Side menu',
              style: TextStyle(
                  color: Color.fromRGBO(200, 53, 53, 1), fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/cover.jpg'),
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.input),
              title: Text('Welcome'),
              onTap: () => {
                    /* Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EventOrganizerApp();
      })) */
                  }),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            // onTap: () => {Navigator.of(context).pop()},
            onTap: () async {
              await auth.signout();
              await GoogleSignIn().signOut();
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> filteredImage = image;
  List<String> filteredTitle = title;
   String _userId = ""; // Initialize user ID
  List<String> _preferredDomains = []; // Initialize preferred domains

  // Filter options
  List<String> categories = ['Hackathon', 'Ideathon', 'Idea Pitching'];
  List<String> districts = ['Kottayam', 'Kollam', 'Ernankulam'];
  List<String> universities = ['RIT', 'CET', 'MACE'];

  RangeValues _currentRangeValues = const RangeValues(20, 60);

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      await _fetchPreferredDomains();
    }
  }

   Future<void> _fetchPreferredDomains() async {
    try {
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(_userId).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>; // Cast to Map
        if (data != null && data.containsKey('preferred')) {
          setState(() {
            _preferredDomains = List<String>.from(data['preferred']);
          });
        }
      }
    } catch (e) {
      print("Error fetching preferred domains: $e");
    }
  }

  Future<List<String>> _fetchEventsForPreferredDomains() async {
    try {
      final QuerySnapshot eventsQuery = await _firestore.collection('events')
          .where('domain', whereIn: _preferredDomains)
          .get();
      final List<String> eventNames = eventsQuery.docs.map((doc) => doc['name'] as String).toList();
      return eventNames;
    } catch (e) {
      print("Error fetching events: $e");
      return []; // Return an empty list if no data or error
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
    AuthService _auth = AuthService();
    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: Colors.grey[850],
      drawer: NavDrawer(), // Integrate NavDrawer here

      // appBar: AppBar(
      //   title: Text('Your App Title'),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 330,
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
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: IconButton(
                    // iconSize: 200,
                    icon: Image.asset("assets/images/filter_logo.png"),

                    onPressed: () {
                      // Show filter options
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Filters"),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  // Category filter
                                  DropdownButtonFormField<String>(
                                    value: categories.first,
                                    items: categories.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      // Handle category filter change
                                      setState(() {
                                        // Update selected category
                                      });
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
                                    items: districts.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      // Handle district filter change
                                      setState(() {
                                        // Update selected district
                                      });
                                    },
                                  ),

                                  // University filter
                                  DropdownButtonFormField<String>(
                                    value: universities.first,
                                    items: universities.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      // Handle university filter change
                                      setState(() {
                                        // Update selected university
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Apply filters
                                  applyFilters();
                                  Navigator.of(context).pop();
                                },
                                child: Text("Apply"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // ,Padding(
          // padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),

          // ),
          // ),
          // FloatingActionButton(
          //           onPressed: () {
          //             // Validate returns true if the form is valid, or false otherwise.
          //             _scaffoldKey.currentState!.openDrawer();
          //           },
          //           child: Icon(Icons.add)
          //           ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, // Adjust as needed
              ),
              itemCount: image.length,
              itemBuilder: (BuildContext context, int index) {
                return CardItem(image: image[index], title: title[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer(); // Open the NavDrawer
        },
        child: Icon(Icons.menu),
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
                  fit: BoxFit.cover,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return userEventRegistration();
        }));
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
