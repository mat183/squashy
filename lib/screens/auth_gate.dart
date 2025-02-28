import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squashy/providers/auth_provider.dart';
import 'package:squashy/providers/fcm_provider.dart';
import 'package:squashy/screens/login_screen.dart';
import 'package:squashy/screens/main_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateStreamProvider);

    ref.listen(authStateStreamProvider, (_, user) {
      ref.read(updateFcmTokenProvider.future);
    });

    return authState.when(
      data: (user) => user == null ? const LoginScreen() : const MainScreen(),
      error: (error, _) => Text('Error: $error'),
      loading: () => CircularProgressIndicator(),
    );
  }
}
