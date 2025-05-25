import 'dart:async';
import 'package:fyp/screen/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/widget/custom_loading.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false;
  bool _isVerified = false;
  Timer? _timer;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = _authService.currentUser?.email;
    _startVerificationCheck();
    _startResendCooldown();
  }

  void _startVerificationCheck() {
    _checkEmailVerified();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkEmailVerified();
    });
  }

  void _startResendCooldown() {
    setState(() => _resendCooldown = 30);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        setState(() => _resendCooldown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _checkEmailVerified() async {
    await _authService.currentUser?.reload();
    final user = _authService.currentUser;

    if (user != null && user.emailVerified) {
      _timer?.cancel();
      _cooldownTimer?.cancel();
      setState(() => _isVerified = true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
            (route) => false,
      );
    }
  }

  Future<void> _resendVerification() async {
    if (_resendCooldown > 0) return;

    setState(() => _isLoading = true);
    try {
      await _authService.sendVerificationEmail();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent! Check your inbox.'),
          backgroundColor: Colors.green,
        ),
      );
      _startResendCooldown();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Icon(
                Icons.mark_email_unread_outlined,
                size: 100,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.blue.shade800,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_userEmail != null)
              Text(
                'Sent to: $_userEmail',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'We\'ve sent a verification link to your email address. '
                    'Please check your inbox and click the link to complete your registration.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (_isLoading)
              const CustomLoading()
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _resendCooldown > 0 ? null : _resendVerification,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _resendCooldown > 0
                            ? 'Resend in $_resendCooldown sec'
                            : 'Resend Verification Email',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Didn\'t receive the email?',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },
              child: Text(
                'Back to Login',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Check your spam or junk folder if you didn’t receive it.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
