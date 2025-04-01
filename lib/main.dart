import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squashy/firebase_options.dart';
import 'package:squashy/screens/scheduled_matches.dart';
import 'package:squashy/screens/splash.dart';
// import 'package:squashy/utils/theme.dart';
import 'package:squashy/screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      // For now my custom theme is disabled. It will be polished soon...
      // theme: appTheme(context, false),
      // darkTheme: appTheme(context, true),
      themeMode: ThemeMode.system,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            return const ScheduledMatchesScreen();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
