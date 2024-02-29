import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:merume_mobile/api/auth_api/access_token_api.dart';
import 'package:merume_mobile/utils/exceptions.dart';

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
  final accessToken = await storage.read(key: 'accessToken');
  try {
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

    if (e is FirebaseAuthException) {
      if (accessToken != null && isTokenExpired(accessToken)) {
        try {
          final accessToken = await getNewAccessToken();

          if (accessToken != null) {
            await FirebaseAuth.instance.signInWithCustomToken(accessToken);
            if (FirebaseAuth.instance.currentUser != null) {
              return true; // Authentication successful
            } else {
              return false; // Authentication failed
            }
          } else {
            throw TokenErrorException('Token auth error');
          }
        } catch (accessTokenError) {
          rethrow;
        }
      } else {
        throw TokenErrorException('Token auth error');
      }
    } else {
      throw TokenErrorException('Token auth error');
    }
  }
}

bool isTokenExpired(String token) {
  final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  final DateTime expirationDate =
      DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
  final DateTime now = DateTime.now();
  return now.isAfter(expirationDate);
}

Future<void> deleteCurrentFirebaseUser() async {
  try {
    // Get the current user from FirebaseAuth
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Delete the user from FirebaseAuth
      await currentUser.delete();
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error deleting user from Firebase: $e');
    }

    rethrow;
  }
}
