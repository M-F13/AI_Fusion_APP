import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screen/signup_page.dart';
import 'package:fyp/screen/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../helper/pref.dart';
import '../widget/custom_loading.dart';
import '../widget/form_container_widget.dart';
import 'login_page.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    setState(() => _isLoading = true);

    final user = _authService.currentUser;
    final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(user?.email ?? '');

    setState(() => _isLoading = false);

    if (methods.contains('google.com')) {
      // Google Sign-In user: skip password fields
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('This will permanently delete your Google account data. Continue?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
          ],
        ),
      );

      if (confirm == true) {
        try {
          await _authService.signInWithGoogle(context); // re-authenticate
          await user?.delete();
          await FirebaseAuth.instance.signOut();
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignupPage()),
                  (route) => false,
            );
          }
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (_) => const SignupPage()),
          //       (route) => false,
          // );

          Navigator.pushNamedAndRemoveUntil(context, '/signup', (route) => false);


          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deleted'), backgroundColor: Colors.green),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
          );
        }
      }
    } else {
      // Email/Password user: validate form
      if (!_formKey.currentState!.validate()) return;

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('This will permanently delete your account and all data. Are you sure?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
          ],
        ),
      );

      if (confirm == true) {
        try {
          await _authService.deleteUserAccount(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

          // Clear all local data
          await Pref.clearUserData();

          if (mounted) {
            Get.offAll(() => const LoginPage()); // Use GetX for consistent navigation
          }
        }  catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGoogleUser = _authService.currentUser?.providerData.any((p) => p.providerId == 'google.com') ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Deletion'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.orange.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Delete Your Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.red.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This action cannot be undone. All your data will be permanently removed.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 30),

                  if (!isGoogleUser) ...[
                    Text(
                      "Email Address",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FormContainerWidget(
                      controller: _emailController,
                      hintText: "your@email.com",
                      isPasswordField: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Password",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FormContainerWidget(
                      controller: _passwordController,
                      hintText: "Enter your password",
                      isPasswordField: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _deleteAccount,
                      child: const Text(
                        'Permanently Delete Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) const CustomLoading(),
        ],
      ),
    );
  }
}
