import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final messageStreamController = BehaviorSubject<RemoteMessage>();

  static Future<void> initialize() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      messageStreamController.add(initialMessage);
    }

    FirebaseMessaging.onMessage.listen(
      (message) {
        if (kDebugMode) {
          print(
              'Handling a foreground message (onMessage): ${message.messageId}');
          print('Message data: ${message.data}');
        }

        messageStreamController.add(message);
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print(
            'Handling a foreground message (onMessageOpenedApp): ${message.messageId}');
        print('Message data: ${message.data}');
      }

      messageStreamController.add(message); // Forward to BehaviorSubject
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (kDebugMode) {
      print('Handling a background message: ${message.messageId}');
      print('Message data: ${message.data}');
    }

    messageStreamController.add(message);
  }
}
