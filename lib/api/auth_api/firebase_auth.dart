import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String?> loginInFirebase(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  } catch (e) {
    if (kDebugMode) {
      print('Login Error: $e');
    }

    rethrow;
  }
}

Future<String?> registerInFirebase(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  } catch (e) {
    if (kDebugMode) {
      print('Registration Error: $e');
    }

    rethrow;
  }
}

Future<void> logoutFromFirebase() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    if (kDebugMode) {
      print('Logout Error: $e');
    }

    rethrow;
  }
}

Future<bool> verifyAuthInFirebase() async {
  const storage = FlutterSecureStorage();
  try {
    final accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      await FirebaseAuth.instance.signInWithCustomToken(accessToken);
      return true; // Authentication successful
    } else {
      return false; // No accessToken found
    }
  } catch (e) {
    if (kDebugMode) {
      print('Verify FirebaseAuth Error: $e');
    }

    return false; // Error during authentication
  }
}
