import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Pref {
  static late Box _box;

  static Future<void> initialize() async {
    //for initializing hive to use app directory
    // Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
    // _box = Hive.box(name: 'myData');

    await Hive.initFlutter();
    _box = await Hive.openBox('myData');
  }

  static Future<void> clearUserData() async {
    await _box?.clear(); // If using Hive
    // Clear any other stored preferences
    userName = '';
    userEmail = null;
    // Add any other user-related preferences you need to clear
  }

  static bool get showOnboarding =>
      _box.get('showOnboarding', defaultValue: true);
  static set showOnboarding(bool v) => _box.put('showOnboarding', v);

  // Normal Way - Get
  // how to call
  // showOnboarding()

  // static bool showOnboarding() {
  //   return _box.get('showOnboarding', defaultValue: true);
  // }

  // Normal Way - Set
  // how to call
  // showOnboarding(false)

  // static bool showOnboarding(bool v) {
  //   _box.put('showOnboarding', v);
  // }

  // Add to your Pref class
  // In pref.dart
  static String get userName => _box.get('userName', defaultValue: '');
  static set userName(String value) => _box.put('userName', value);

  static String get profilePicUrl => _box.get('profilePicUrl', defaultValue: '');
  static set profilePicUrl(String value) => _box.put('profilePicUrl', value);

  //for storing theme data
  static bool get isDarkMode => _box.get('isDarkMode') ?? false;
  static set isDarkMode(bool v) => _box.put('isDarkMode', v);

  // for email in navigation drawer
  static String? get userEmail => _box.get('userEmail');
  static set userEmail(String? value) {
    if (value == null) {
      _box.delete('userEmail');
    } else {
      _box.put('userEmail', value);
    }
  }

  static ThemeMode get defaultTheme {
    final data = _box.get('isDarkMode');
    log('data: $data');
    if (data == null) return ThemeMode.system;
    if (data == true) return ThemeMode.dark;
    return ThemeMode.light;
  }
}
