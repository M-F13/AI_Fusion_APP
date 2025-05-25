
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required BuildContext context,
  required String message,
  ToastificationType type = ToastificationType.info,
}) {
  toastification.show(
    context: context,
    title: Text(message),
    type: type,
    style: ToastificationStyle.flat,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 300),
    showProgressBar: true,
    icon: Icon(Icons.info, color: Colors.white),
    primaryColor: Colors.blue,
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  );
}
