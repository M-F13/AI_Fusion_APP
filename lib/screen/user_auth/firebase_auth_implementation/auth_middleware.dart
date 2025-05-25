import 'package:firebase_auth/firebase_auth.dart';

class AuthMiddleware {
  static Future<User?> getVerifiedUser(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        return null;
      }

      return userCredential.user;
    } on FirebaseAuthException {
      return null;
    }
  }
}