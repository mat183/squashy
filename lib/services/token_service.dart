import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TokenService {
  static Future<void> saveToken(User user) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? fcmToken = await messaging.getToken();

      if (fcmToken == null) {
        print(
            'Firebase cloud messaging won\'t be enabled for user ${user.uid}');
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'name': user.displayName ?? 'Unknown',
          'email': user.email ?? 'Unknown',
          'fcmToken': fcmToken ?? '',
        },
        SetOptions(merge: true),
      );
    } else {
      print('Notification permission denied.');
    }
  }

  static void listenForTokenChanges(User user) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.onTokenRefresh.listen((newToken) async {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {
          'fcm_token': newToken,
        },
      );
    });
  }
}
