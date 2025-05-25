import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fyp/helper/pref.dart';
import 'package:fyp/screen/signup_page.dart';
import 'package:fyp/screen/delete_account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/profile_edit_page.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final BuildContext context;
  final RxBool isDarkMode;
  final VoidCallback onLogout;

  const CustomNavigationDrawer({
    super.key,
    required this.context,
    required this.isDarkMode,
    required this.onLogout,
  });


  @override
  Widget build(BuildContext context) {
    final userName = Pref.userName;
// Get first character of first name only
    final initials = userName.isNotEmpty
        ? userName.split(' ').first[0].toUpperCase()
        : 'U';

    
    return Drawer(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: isDarkMode.value
          //       ? [Colors.blue.shade900, Colors.purple.shade900]
          //       : [Colors.blue.shade100, Colors.purple.shade100],
          // ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode.value
                ? [
              // Dark mode colors - blue dominant with subtle purple
              Colors.blue.shade900.withOpacity(0.8),
              Colors.indigo.shade800.withOpacity(0.8),
            ]
                : [
              // Light mode colors - soft blue with lavender accent
              Colors.blue.shade50.withOpacity(0.9),
              Colors.lightBlue.shade100.withOpacity(0.9),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(initials, userName, isDarkMode.value),
            _buildThemeToggle(isDarkMode.value),
            _buildAboutUsOption(),
            _buildLogoutOption(),
            _buildDeleteAccountOption(),
          ],
        ),
      ),
    );
  }









  // Updated CustomNavigationDrawer
  Widget _buildDrawerHeader(String initials, String userName, bool isDark) {
    final userEmail = Pref.userEmail ?? 'No email provided'; // Now using Hive

    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode.value
              ? [Color(0xFF0D1B2A), Color(0xFF1B263B)]
              : [Colors.blue.shade200, Colors.blue.shade300],
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: isDark ? Colors.white : Colors.blue.shade900,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 28,
                    color: isDark ? Colors.blue.shade900 : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white.withOpacity(0.8)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileEditPage()),
                  ).then((updated) {
                    if (updated == true) {
                      // Refresh the drawer if updates were made
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            userName.isNotEmpty ? userName : 'Guest User',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            userEmail,
            style: TextStyle(
              // color: Colors.blue.shade900,
              color: Colors.white.withOpacity(0.8),
              fontSize: 14, fontWeight: FontWeight.bold
            ),
          ),
          if (userName.isEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileEditPage()),
                );
              },
              child: Text(
                'Complete your profile',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
        ],
      ),
    );
  }





  Widget _buildThemeToggle(bool isDark) {
    // Detect current theme from context
    final isCurrentlyDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        isCurrentlyDark ? Icons.mode_night : Icons.sunny,
        color: Colors.blueAccent.shade400,
        size: 26,
      ),
      title: Text(
        isCurrentlyDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        style: TextStyle(
          color: isCurrentlyDark ? Colors.white : Colors.black,
        ),
      ),
      onTap: () {
        final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
        Get.changeThemeMode(newMode);
        isDarkMode.value = newMode == ThemeMode.dark;
        Pref.isDarkMode = isDarkMode.value;
        Navigator.pop(context);
      },
    );
  }




  ListTile _buildAboutUsOption() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(Icons.info, color: Colors.blueAccent.shade400),
      title: Text('About AI Fusion',
          // style: TextStyle(fontSize: 16)
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer first
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [Colors.blue.shade900, Colors.indigo.shade800]
                      : [Colors.blue.shade50, Colors.lightBlue.shade100],
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 40,
                      color: isDark ? Colors.white : Colors.blue.shade800),
                  SizedBox(height: 16),
                  Text('AI Fusion',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.blue.shade900,
                      )),
                  SizedBox(height: 20),
                  Text(
                    'AI Fusion is a comprehensive AI suite that combines advanced chatbot capabilities, '
                        'creative image generation, multilingual translation, and document scanning technologies '
                        'into a single, intuitive platform designed to enhance productivity and creativity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.blueGrey.shade800,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text('Developed by Maheen Fatima',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.blueGrey.shade700,
                      )),
                  SizedBox(height: 8),
                  // InkWell(
                  //   onTap: () async {
                  //     try {
                  //       // Try direct Gmail link first (Android)
                  //       if (Platform.isAndroid) {
                  //         final gmailUri = Uri.parse(
                  //             'https://mail.google.com/mail/?view=cm&fs=1'
                  //                 '&to=mf.dev313@gmail.com'
                  //                 '&su=AI%20Fusion%20Feedback'
                  //                 '&body=Hello%20Maheen%0A%0AI%20wanted%20to%20say...'
                  //         );
                  //
                  //         if (await canLaunchUrl(gmailUri)) {
                  //           await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
                  //           return;
                  //         }
                  //       }
                  //
                  //       // Fallback to standard mailto
                  //       final mailtoUri = Uri(
                  //         scheme: 'mailto',
                  //         path: 'mf.dev313@gmail.com',
                  //         queryParameters: {
                  //           'subject': 'AI Fusion Feedback',
                  //           'body': 'Hello Maheen,\n\nI wanted to say...',
                  //         },
                  //       );
                  //
                  //       if (await canLaunchUrl(mailtoUri)) {
                  //         await launchUrl(mailtoUri);
                  //       } else {
                  //         // Final fallback
                  //         await Clipboard.setData(ClipboardData(text: 'mf.dev313@gmail.com'));
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(content: Text('Email copied to clipboard')),
                  //         );
                  //       }
                  //     } catch (e) {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(content: Text('Error: ${e.toString()}')),
                  //       );
                  //     }
                  //   },
                  //   child: Text(
                  //     'mf.dev313@gmail.com',
                  //     style: TextStyle(
                  //       color: Colors.blueAccent,
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //   ),
                  // ),



                  InkWell(
                    onTap: () => _launchEmail(context),
                    child: Text(
                      'mf.dev313@gmail.com',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  

                  SizedBox(height: 16),
                  TextButton(
                    child: Text('Close',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  Widget _buildFeatureTile(IconData icon, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blueAccent.shade400),
      title: Text(text,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.blueGrey.shade800,
          )),
      minLeadingWidth: 0,
    );
  }

  Widget _buildTechPill(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Text(text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey.shade700,
            )),
      ),
    );
  }



  // ListTile _buildAboutUsOption() {
  //   return ListTile(
  //     leading: const Icon(Icons.info),
  //     title: const Text('About Us'),
  //     onTap: () {
  //       Navigator.pop(context);
  //       // Show about us dialog
  //     },
  //   );
  // }

  ListTile _buildLogoutOption() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.blueAccent),
      title: const Text('Logout'),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Confirm Logout"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onLogout();
                },
                child: const Text("Logout", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }


  ListTile _buildDeleteAccountOption() {
    return ListTile(
      leading: const Icon(Icons.delete_forever, color: Colors.red),
      title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeleteAccountScreen()),
        );
      },
    );
  }
}

// Future<void> _logout(BuildContext context) async {
//   await FirebaseAuth.instance.signOut();
//
//   // Optional: Clear SharedPreferences or Hive
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.clear(); // Or specific keys if needed
//
//   // Navigate to login screen
//   if (context.mounted) {
//     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//   }
// }


Future<void> _launchEmail(BuildContext context) async {
  const email = 'mf.dev313@gmail.com';
  const subject = 'AI Fusion Feedback';
  const body = 'Hello Maheen,\n\nI wanted to say...';

  try {
    // Try direct Gmail app URI (works if Gmail is installed)
    final gmailUri = Uri.parse(
        'googlegmail:///co?to=$email&subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}'
    );

    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(gmailUri);
      return;
    }

    // Try Android mailto intent
    final mailtoUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
      return;
    }

    // Try web Gmail as fallback
    final webGmailUri = Uri.parse(
        'https://mail.google.com/mail/?view=cm&fs=1'
            '&to=$email'
            '&su=${Uri.encodeComponent(subject)}'
            '&body=${Uri.encodeComponent(body)}'
    );

    if (await canLaunchUrl(webGmailUri)) {
      await launchUrl(webGmailUri, mode: LaunchMode.externalApplication);
      return;
    }

    // Final fallback - copy to clipboard
    await Clipboard.setData(const ClipboardData(text: email));
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email copied to clipboard. Please paste it in your email app'),
        duration: Duration(seconds: 3),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}