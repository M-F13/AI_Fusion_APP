



import 'package:fyp/main.dart';
import 'package:fyp/screen/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/widget/custom_loading.dart';
import 'package:fyp/widget/form_container_widget.dart';
import 'package:fyp/screen/signup_page.dart';
import 'package:fyp/screen/forgot_password_page.dart';
import 'package:fyp/screen/email_verification_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  bool _obscurePassword = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // SignIn with Google option
  Future<void> _signInWithGoogle() async {
    setState(() => _isSigning = true);
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
        setState(() => _isSigning = false);
      }
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSigning = true);
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      final user = await _auth.signInWithEmailAndPassword(
          context, // Pass the BuildContext
        _emailController.text.trim(),
        _passwordController.text,

      );

      if (user != null) {
        if (!user.emailVerified) {
          await _auth.sendVerificationEmail();
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmailVerificationScreen(),
            ),
          );
          return;
        }

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          message = 'Invalid email or password';
          await Future.delayed(const Duration(seconds: 1)); // Security delay
          break;
        case 'user-disabled':
          message = 'Account disabled. Contact support.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later.';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSigning = false);
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
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Login to continue",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color
                                    ?.withOpacity(0.7),
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              "Email",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color
                                    ?.withOpacity(0.7),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                isDark ? Colors.grey[900] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FormContainerWidget(
                                controller: _emailController,
                                hintText: "Enter Email",
                                isPasswordField: false,
                                textColor:
                                isDark ? Colors.white : Colors.black87,
                                hintColor:
                                isDark ? Colors.grey[500] : Colors.grey[600],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Enter valid email';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Password",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color
                                    ?.withOpacity(0.7),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                isDark ? Colors.grey[900] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FormContainerWidget(
                                controller: _passwordController,
                                hintText: "Enter Password",
                                isPasswordField: true,
                                obscureText: _obscurePassword,
                                textColor:
                                isDark ? Colors.white : Colors.black87,
                                hintColor:
                                isDark ? Colors.grey[500] : Colors.grey[600],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password too short';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _signIn(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(
                                          () => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: theme.buttonColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: ElevatedButton(
                                  onPressed: _isSigning ? null : _signIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.buttonColor,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                    minimumSize: const Size(double.infinity, 44),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: _isSigning
                                      ? const CircularProgressIndicator(
                                      color: Colors.white)
                                      : const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 20),

                            // login with google
                            const SizedBox(height: 10),
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
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: OutlinedButton(
                                onPressed: _isSigning ? null : _signInWithGoogle,
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
                                      "assets/images/google_logo.png", // Add a Google logo asset
                                      height: 24,
                                      width: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),



                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: theme.textTheme.bodyLarge?.color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const SignupPage()),
                                          (route) => false,
                                    );
                                  },
                                  child: Text(
                                    "SignUp",
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
          if (_isSigning) const CustomLoading(),
        ],
      ),
    );
  }
}






