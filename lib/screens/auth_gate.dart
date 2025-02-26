import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:squashy/screens/main_screen.dart';
import 'package:squashy/services/token_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                clientId: 'CLIENT_ID',
              ),
            ],
            actions: [
              AuthStateChangeAction<AuthFailed>((ctx, state) {
                print('❌ Sign-in failed: ${state.exception}');
              }),
              AuthStateChangeAction<SignedIn>((ctx, state) {
                if (state.user != null) {
                  print('✅ Sign-in success: ${state.user!.uid}');
                  TokenService.saveToken(state.user!);
                  TokenService.listenForTokenChanges(state.user!);
                } else {
                  print('No user logged in!');
                }
              }),
            ],
            headerBuilder: (ctx, constraints, shrinkOffset) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset('assets/flutterfire_300x.png'),
              ),
            ),
            subtitleBuilder: (ctx, action) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: action == AuthAction.signIn
                  ? const Text('Welcome to Squashy, please sign in!')
                  : const Text('Welcome to Squashy, please sign up!'),
            ),
            footerBuilder: (ctx, action) => const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'By signing in, you agree to our terms and conditions.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return const MainScreen();
      },
    );
  }
}
