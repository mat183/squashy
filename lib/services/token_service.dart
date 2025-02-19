import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TokenService {
  Future<void> saveToken(String userId) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();

      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set(
          {
            'fcm_token': token,
          },
          SetOptions(merge: true),
        );
      }
    } else {
      print('Notification permission denied.');
    }
  }

  void listenForTokenChanges(String userId) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.onTokenRefresh.listen((newToken) async {
      await FirebaseFirestore.instance.collection('users').doc(userId).update(
        {
          'fcm_token': newToken,
        },
      );
    });
  }
}
