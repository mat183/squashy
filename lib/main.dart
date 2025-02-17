import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:squashy/firebase_options.dart';
import 'package:squashy/utils/theme.dart';
import 'package:squashy/widgets/auth_gate.dart';

final messageStreamController = BehaviorSubject<RemoteMessage>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
  print('Message notification: ${message.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission();
  final token = await messaging.getToken();

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
    print('Registration Token = ${token ?? ''}');
  }

  // For foreground messages
  FirebaseMessaging.onMessage.listen(
    (message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }

      messageStreamController.sink.add(message);
    },
  );
  // For background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squashy',
      theme: appTheme(context, false),
      darkTheme: appTheme(context, true),
      themeMode: ThemeMode.system,
      home: const AuthGate(),
    );
  }
}
