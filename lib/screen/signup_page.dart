

import 'package:fyp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screen/login_page.dart';
import 'package:fyp/screen/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:fyp/widget/form_container_widget.dart';
import 'package:fyp/widget/custom_loading.dart';
import 'package:fyp/helper/pref.dart';
import 'package:fyp/screen/email_verification_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isSigningUp = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  // Signup with Google option
  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningUp = true);
    try {
      final user = await _auth.signInWithGoogle(context);
      if (user != null && mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
              (route) => false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSigningUp = false);
      }
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSigningUp = true);
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      final user = await _auth.signUpWithEmailAndPassword(
        context, // Pass the BuildContext
        _emailController.text.trim(),
        _passwordController.text,
        _usernameController.text.trim(),
      );

      if (user != null) {
        // Save username to preferences
        Pref.userName = _usernameController.text.trim();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EmailVerificationScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address';
          break;
        case 'weak-password':
          errorMessage = 'Password should be at least 6 characters';
          break;
        default:
          errorMessage = e.message ?? 'Signup failed';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSigningUp = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/bg_image.png"),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Create account",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Name",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[900] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FormContainerWidget(
                                controller: _usernameController,
                                hintText: "Enter your name",
                                textColor: isDark ? Colors.white : Colors.black87,
                                hintColor: isDark ? Colors.grey[500] : Colors.grey[600],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  if (value.length < 3) {
                                    return 'Name too short';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Email",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[900] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FormContainerWidget(
                                controller: _emailController,
                                hintText: "Enter Email",
                                textColor: isDark ? Colors.white : Colors.black87,
                                hintColor: isDark ? Colors.grey[500] : Colors.grey[600],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Password",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[900] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FormContainerWidget(
                                controller: _passwordController,
                                hintText: "Enter Password (min 6 chars)",
                                isPasswordField: true,
                                obscureText: _obscurePassword,
                                textColor: isDark ? Colors.white : Colors.black87,
                                hintColor: isDark ? Colors.grey[500] : Colors.grey[600],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be 6+ characters';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Confirm Password",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[900] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FormContainerWidget(
                                controller: _confirmPasswordController,
                                hintText: "Confirm Password",
                                isPasswordField: true,
                                obscureText: _obscureConfirmPassword,
                                textColor: isDark ? Colors.white : Colors.black87,
                                hintColor: isDark ? Colors.grey[500] : Colors.grey[600],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _signUp(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSigningUp ? null : _signUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.buttonColor,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  minimumSize: const Size(double.infinity, 44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: _isSigningUp
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 20),


                            // Signup with google option
                            const SizedBox(height: 5),
                            Center(
                              child: const Text(
                                "Or",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: _isSigningUp ? null : () async {
                                  setState(() => _isSigningUp = true);
                                  try {
                                    final user = await _auth.signInWithGoogle(context);
                                    if (user != null && mounted) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/home',
                                            (route) => false,
                                      );
                                    }
                                  } finally {
                                    if (mounted) setState(() => _isSigningUp = false);
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  minimumSize: const Size(double.infinity, 44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  side: BorderSide(color: theme.buttonColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/google_logo.png",
                                      height: 24,
                                      width: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: theme.textTheme.bodyLarge?.color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                          (route) => false,
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: theme.buttonColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isSigningUp) const CustomLoading(),
        ],
      ),
    );
  }
}






