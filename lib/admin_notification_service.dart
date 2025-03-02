// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class AdminNotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   void initialize() {
//     _firebaseMessaging.requestPermission();

//     FirebaseFirestore.instance
//         .collection('teacher_requests')
//         .snapshots()
//         .listen((snapshot) {
//       for (var doc in snapshot.docChanges) {
//         if (doc.type == DocumentChangeType.added) {
//           _sendNotification("New Teacher Request",
//               "A new teacher request has been submitted.");
//         }
//       }
//     });
//   }

//   void _sendNotification(String title, String body) {
//     var android = AndroidNotificationDetails('channel_id', 'channel_name',
//         importance: Importance.max);
//     var details = NotificationDetails(android: android);
//     _localNotifications.show(0, title, body, details);
//   }
// }
