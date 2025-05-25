

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../helper/pref.dart';
import '../../../helper/toast.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  // Google Sign-In
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Clear any cached credentials
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Configure GoogleSignIn to always show account selection
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Store user details
      Pref.userName = userCredential.user?.displayName ?? '';
      Pref.userEmail = userCredential.user?.email;

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      showToast(
          message: e.message ?? 'Google sign-in failed',
          context: context
      );
      return null;
    } catch (e) {
      showToast(
          message: 'Error during Google sign-in',
          context: context
      );
      return null;
    }
  }

  // Sign out from Google
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }

  // for email in navigation drawer
  Future<bool> checkEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Improved account existence check
  Future<bool> doesAccountExist(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Sign up with email/password
  Future<User?> signUpWithEmailAndPassword(BuildContext context,
      String email,
      String password,
      String username) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user display name and store in Hive
      await credential.user?.updateProfile(displayName: username);
      Pref.userName = username;
      Pref.userEmail = email; // Store email in Hive

      // Send verification email
      await sendVerificationEmail();
      showToast(message: 'Verification email sent to $email', context: context);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'Account already exists. Please login instead.',
            context: context);
      } else {
        showToast(message: e.message ?? 'Signup failed', context: context);
      }
      return null;
    }
  }


  // Sign in with email/password
  Future<User?> signInWithEmailAndPassword(BuildContext context,
      String email,
      String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!credential.user!.emailVerified) {
        await sendVerificationEmail();
        showToast(message: 'Please verify your email first. New link sent.',
            context: context);
        await _auth.signOut();
        return null;
      }

      // Store user email in Hive
      Pref.userEmail = credential.user?.email;
      return credential.user;
    } on FirebaseAuthException catch (e) {
      showToast(message: e.message ?? 'Login failed', context: context);
      return null;
    }
  }

  // Password reset functionality
  Future<void> sendPasswordResetEmail(BuildContext context,
      String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showToast(
          message: 'Password reset link sent to $email', context: context);
    } on FirebaseAuthException catch (e) {
      showToast(
          message: e.message ?? 'Password reset failed', context: context);
      rethrow;
    }
  }

  // Account deletion with re-authentication
  Future<void> deleteUserAccount({String? email, String? password}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      AuthCredential? credential;

      // Use appropriate credential based on sign-in method
      if (user.providerData.any((info) => info.providerId == 'google.com')) {
        // Re-authenticate Google user
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) throw Exception('Google sign-in aborted');

        final googleAuth = await googleUser.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } else if (email != null && password != null) {
        // Re-authenticate Email/Password user
        credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
      } else {
        throw Exception('No valid credential provided');
      }

      // Re-authenticate and delete
      await user.reauthenticateWithCredential(credential);
      await user.delete();
      await _auth.signOut();
      await _googleSignIn.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Account deletion failed');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    // Clear any local storage
    await Pref.clearUserData();
  }
}
