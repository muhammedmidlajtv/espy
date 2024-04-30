import "dart:async";
// import 'dart:ffi';
//import 'package:espy/screen/home_screen.dart';
import 'package:espy/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:espy/screen/signup/SignUp.dart';
import 'package:espy/screen/login/Login.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "package:espy/screen/authentication/auth_service.dart";

const SAVE_KEY_NAME = 'UserLoggedIn ';

final TextEditingController eventNameController = TextEditingController();
final TextEditingController organizerNameController = TextEditingController();
final TextEditingController eventTimeController = TextEditingController();
final TextEditingController eventDateController = TextEditingController();
final TextEditingController eventTypeController = TextEditingController();
final TextEditingController skillController = TextEditingController();

final TextEditingController eventDescriptionController =
    TextEditingController();

//chance for ambiguity
final TextEditingController nameController = TextEditingController();
final TextEditingController designationController = TextEditingController();
String imageUrl = "";
String FileName = "";
String eventMode = 'Online'; // Variable to store selected event mode
String? _filePath;

  DateTime? selectedDate; // Variable to store selected date
    List<Map<String, String>> speakers = [];


TextEditingController venueController = TextEditingController();
TextEditingController mapLinkController = TextEditingController();
TextEditingController districtController = TextEditingController();
TextEditingController regLinkController = TextEditingController();
String participationType = 'Individual';
String participationFee = 'Free';
int? participationAmount = 0; // Changed to nullable int
int? minParticipants = 1;
int? maxParticipants = 1;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is c root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Add this line

      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
class CheckUserLoggedInOrNot extends StatefulWidget {
  const CheckUserLoggedInOrNot({super.key});

  @override
  State<CheckUserLoggedInOrNot> createState() => _CheckUserLoggedInOrNotState();
}

class _CheckUserLoggedInOrNotState extends State<CheckUserLoggedInOrNot> {
  @override
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUp()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
  