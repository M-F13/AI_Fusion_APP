// profile_edit_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp/helper/pref.dart';
import 'package:fyp/screen/user_auth/firebase_auth_implementation/firebase_auth_services.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: Pref.userName);
  final _emailController = TextEditingController(text: Pref.userEmail);
  final _authService = FirebaseAuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _nameController.text = Pref.userName;
    _emailController.text = Pref.userEmail ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Update name in local preferences
      Pref.userName = _nameController.text.trim();

      // Update email if changed
      final currentEmail = Pref.userEmail;
      final newEmail = _emailController.text.trim();

      if (currentEmail != newEmail) {
        final user = _authService.currentUser;
        if (user != null) {
          await user.verifyBeforeUpdateEmail(newEmail);
          Pref.userEmail = newEmail;
          Get.snackbar(
            'Success',
            'Verification email sent to your new email address',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }

      Get.back(result: true); // Return success
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
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
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}