// import 'dart:html';
//import "dart:developer";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:espy/screen/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:espy/screen/Login.dart';


List<String> image = [
  'https://cdn.pixabay.com/photo/2017/10/20/10/58/elephant-2870777_960_720.jpg',
  'https://cdn.pixabay.com/photo/2014/09/08/17/32/humming-bird-439364_960_720.jpg',
  'https://cdn.pixabay.com/photo/2018/05/03/22/34/lion-3372720_960_720.jpg'
];
List<String> title = ['Sparrow', 'Elephant', 'Humming Bird', 'Lion'];

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
              style: TextStyle(color: Color.fromRGBO(200, 53, 53, 1), fontSize: 25),
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
            onTap: () => {},
          ),
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
            goToLogin(context);
  },
          ),
        ],
      ),
    );
  }
}

class user_homeLogin extends StatelessWidget {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

   user_homeLogin({Key? key});

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
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child:
             SizedBox(
              // width:10 ,
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
             ),
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
    return Card(
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
    );
  }
}

goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
