import "dart:async";
import 'dart:convert';
// import 'dart:ffi';
//import 'package:espy/screen/home_screen.dart';
import 'package:espy/screen/splash.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "firebase_options.dart";
import "package:espy/screen/notification_service.dart";
import "package:espy/screen/message.dart" as message;

final navigatorKey = GlobalKey<NavigatorState>();

String current_logged_email = "";
String current_user_name = "";

const SAVE_KEY_NAME = 'UserLoggedIn ';

final TextEditingController eventNameController = TextEditingController();
final TextEditingController organizerNameController = TextEditingController();
final TextEditingController eventTimeController = TextEditingController();
final TextEditingController eventDateController = TextEditingController();
//final TextEditingController eventTypeController = TextEditingController();
final TextEditingController skillController = TextEditingController();

final TextEditingController eventDescriptionController =
    TextEditingController();

//chance for ambiguity
final TextEditingController nameController = TextEditingController();
final TextEditingController designationController = TextEditingController();
String imageUrl = "";
String FileName = "";
String eventMode = 'Online'; // Variable to store selected event mode
String eventType = 'Hackathon'; // Variable to store selected event mode
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



Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received in background...");
  }
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SharedPreferences.getInstance().then((prefs) {
  //   // Retrieve values from shared preferences
  //   current_logged_email = prefs.getString('current_logged_email') ?? '';
  //   current_user_name = prefs.getString('current_user_name') ?? '';
  //   runApp(const MyApp());
  // });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotifications.init();
  await PushNotifications.localNotiInit();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // on background notification tapped
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   if (message.notification != null) {
  //     print("Background Notification Tapped");
  //     navigatorKey.currentState!.pushNamed("/message", arguments: message);
  //   }
  // });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  if (message.notification != null) {
    print("Background Notification Tapped");
    navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (context) => user_homeLogin(),
    ));
  }
});
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      // if (kIsWeb) {
      //   showNotification(
      //       title: message.notification!.title!,
      //       body: message.notification!.body!);
      // } else {
        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      // }
    }
  });
  final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => user_homeLogin(),
      ));
    });
  }

  // final RemoteMessage? message =
  //     await FirebaseMessaging.instance.getInitialMessage();

  // if (message != null) {
  //   print("Launched from terminated state");
  //   Future.delayed(Duration(seconds: 1), () {
  //     navigatorKey.currentState!.pushNamed("/message", arguments: message);
  //   });
  // }
  
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
      navigatorKey: navigatorKey,
       routes: {
        "/message": (context) => message.Message()
      },
    );
  }
}
