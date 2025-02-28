import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_provider.g.dart';

@riverpod
Future<void> updateFcmToken(Ref ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return;
  }

  final userDocRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
  final userDoc = await userDocRef.get();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  if (!userDoc.exists) {
    await userDocRef.set({
      'name': user.displayName ?? 'Unknown',
      'email': user.email ?? 'Unknown',
      'fcmToken': fcmToken ?? '',
    });
  } else {
    await userDocRef.update({'fcmToken': fcmToken});
  }
}
