import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squashy/firebase_options.dart';
import 'package:squashy/services/notification_service.dart';
import 'package:squashy/utils/theme.dart';
import 'package:squashy/screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final settings = await FirebaseMessaging.instance.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print('Notifications permission denied!');
  } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Notifications permission granted!');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print("Notifications provisional permission granted (iOS only)");
  }

  await NotificationService.initialize();

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
