import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SignUp with Email and Password
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('SignUp Error: $e');
      rethrow;
    }
  }

  // SignIn with Email and Password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('SignIn Error: $e');
      rethrow;
    }
  }

  // SignOut
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Additional methods for Social Media Authentication (e.g., Google SignIn)
}
