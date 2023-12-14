import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> loginInFirebase(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  } catch (e) {
    print(e.toString());
    rethrow;
  }
}

Future<UserCredential> registerInFirebase(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  } catch (e) {
    print(e.toString());
    rethrow;
  }
}

Future<void> logoutFromFirebase() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e.toString());
    rethrow;
  }
}
