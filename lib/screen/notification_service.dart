//import 'package:espy/screen/organizerscreens/registration.dart';
import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:espy/screen/authentication/auth_service.dart';
import 'package:espy/screen/crud_service.dart';
import 'package:espy/main.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import "package:espy/screen/authentication/auth_service.dart";
// import "package:espy/screen/signup/SignUp.dart";



final FirebaseFirestore _firestore = FirebaseFirestore.instance;


class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  
  }

//final _firebaseMessaging = FirebaseMessaging.instance;
  static Future getDeviceToken({int maxRetires = 3}) async {
    try {
      String? token;
      if (kIsWeb) {
        // get the device fcm token
        token = await _firebaseMessaging.getToken(
            vapidKey:
                "BPA9r_00LYvGIV9GPqkpCwfIl3Es4IfbGqE9CSrm6oeYJslJNmicXYHyWOZQMPlORgfhG8RNGe7hIxmbLXuJ92k");
        print("for web device token: $token");
      } else {
        // get the device fcm token
        token = await _firebaseMessaging.getToken();
        print("for android device token: $token");
      }
      saveTokentoFirestore(token: token!);
      return token;
    } catch (e) {
      print("failed to get device token");
      if (maxRetires > 0) {
        print("try after 10 sec");
        await Future.delayed(Duration(seconds: 10));
        return getDeviceToken(maxRetires: maxRetires - 1);
      } else {
        return null;
      }
    }
  }

  static saveTokentoFirestore({required String token}) async {
    bool isUserLoggedin = await AuthService.isLoggedIn();
    print("User is logged in $isUserLoggedin");
    if (isUserLoggedin) {
      await CRUDService.saveUserToken(token!);
      print("save to firestore");
    }
    // also save if token changes
    _firebaseMessaging.onTokenRefresh.listen((event) async {
      if (isUserLoggedin) {
        await CRUDService.saveUserToken(token!);
        print("save to firestore");
      }
    });
  }
  // initalize local notifications
  static Future localNotiInit() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
  
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid);

    // request notification permissions for android 13 or above
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

//   // on tap local notification in foreground
  // static void onNotificationTap(NotificationResponse notificationResponse) {
  //   navigatorKey.currentState!
  //       .pushNamed("/message", arguments: notificationResponse);
  // }
  static void onNotificationTap(NotificationResponse notificationResponse) {
  navigatorKey.currentState!.push(MaterialPageRoute(
    builder: (context) => user_homeLogin(),
  ));
  }
  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}