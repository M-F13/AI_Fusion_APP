import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helper/global.dart';
import '../helper/pref.dart';
import '../helper/my_dialog.dart';
import '../model/home_type.dart';
import '../widget/home_card.dart';
import '../screen/navigation_drawer.dart';
import 'login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _isDarkMode = Pref.isDarkMode.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false;
    _loadUserData();
    _checkAuth(); // Add auth check on init
  }

  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null && user.displayName != null) {
      Pref.userName = user.displayName!;
    }
  }

  // Add this method to check auth state
  Future<void> _checkAuth() async {
    final user = _auth.currentUser;
    if (user == null) {
      await _signOut(); // Ensure complete sign out
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(isDark),
      body: _buildBody(isDark),
      drawer: CustomNavigationDrawer(
        context: context,
        isDarkMode: _isDarkMode,
        onLogout: _performLogout,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      title: Text(
        appName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: isDark ? Colors.white : Colors.blue.shade900,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
              Colors.blue.shade900.withOpacity(0.8),
              Colors.indigo.shade800.withOpacity(0.8),
            ]
                : [
              Colors.blue.shade50.withOpacity(0.9),
              Colors.lightBlue.shade100.withOpacity(0.9),
            ],
          ),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: isDark ? Colors.white : Colors.blue.shade900,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  Widget _buildBody(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
            Colors.grey.shade900,
            Colors.grey.shade800,
          ]
              : [
            Colors.grey.shade50,
            Colors.grey.shade100,
          ],
        ),
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * .04,
          vertical: mq.height * .02,
        ),
        children: [
          ...HomeType.values.map((e) => HomeCard(homeType: e)),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await Pref.clearUserData(); // Clear all local storage
    } catch (e) {
      debugPrint('Error during sign out: $e');
    }
  }

  void _performLogout() {
    AppDialogs.showLogoutConfirmation(
      context: context,
      onConfirm: () async {
        try {
          await _signOut();
          if (mounted) {
            Get.offAll(() => const LoginPage());
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logout failed: ${e.toString()}')),
            );
          }
        }
      },
    );
  }
}