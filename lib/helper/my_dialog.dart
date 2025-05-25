import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/custom_loading.dart';

class MyDialog {
//info
  static void info(String msg) {
    Get.snackbar('Info', msg,
        backgroundColor: Colors.blue.withOpacity(.7), colorText: Colors.white);
  }

//success
  static void success(String msg) {
    Get.snackbar('Success', msg,
        backgroundColor: Colors.green.withOpacity(.7), colorText: Colors.white);
  }

//error
  static void error(String msg) {
    Get.snackbar('Error', msg,
        backgroundColor: Colors.redAccent.withOpacity(.7),
        colorText: Colors.white);
  }

  //loading dialog
  static void showLoadingDialog() {
    Get.dialog(const Center(child: CustomLoading()));
  }
}



class AppDialogs {
  static void showSwitchAccountConfirmation({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => _SwitchAccountDialog(onConfirm: onConfirm),
    );
  }

  static void showLogoutConfirmation({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => _LogoutDialog(onConfirm: onConfirm),
    );
  }
}

class _SwitchAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _SwitchAccountDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      title: 'Switch Account',
      content: 'Do you want to switch accounts?',
      onConfirm: onConfirm,
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _LogoutDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      title: 'Logout',
      content: 'Do you want to logout?',
      onConfirm: onConfirm,
    );
  }
}

class _BaseDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const _BaseDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}