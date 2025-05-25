import 'dart:async';
import 'dart:developer' as dev;
import 'dart:typed_data';  // Add this import
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../apis/apis.dart';
import '../helper/global.dart';
import '../helper/my_dialog.dart';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();
  final status = Status.none.obs;
  final imageBytes = Rx<Uint8List?>(null);  // Now properly recognized

  void shareImage() async {
    if (imageBytes.value == null) {
      MyDialog.info('No image to share!');
      return;
    }

    try {
      MyDialog.showLoadingDialog();

      final dir = await getTemporaryDirectory();
      final file = await File('${dir.path}/ai_image.png').writeAsBytes(imageBytes.value!);

      Get.back();

      await Share.shareXFiles([XFile(file.path)],
        text: 'Check out this Amazing Image from AI Fusion App by Maheen Fatima',
      );
    } catch (e) {
      Get.back();
      MyDialog.error('Something Went Wrong (Try again in sometime)!');
      log('shareImage error: $e');
    }
  }

  Future<void> searchAiImage() async {
    if (textC.text.trim().isEmpty) return;

    status.value = Status.loading;
    imageBytes.value = null;

    // Try Stable Horde first
    Uint8List? bytes = await _tryStableHorde();

    // Fallback to Replicate if needed
    // if (bytes == null && replicateApiKey.isNotEmpty) {
    //   bytes = await _tryReplicate();
    // }

    if (bytes != null) {
      imageBytes.value = bytes;
      status.value = Status.complete;
    } else {
      status.value = Status.none;
      MyDialog.error('''
Failed to generate image. Possible reasons:
1. Server is overloaded (try again later)
2. Prompt was blocked (try different words)
3. Network issues (check connection)
    ''');
    }
  }

  Future<Uint8List?> _tryStableHorde() async {
    try {
      return await APIs.generateImage(textC.text)
          .timeout(const Duration(minutes: 2));
    } catch (e) {
      debugPrint('Stable Horde failed: $e');
      return null;
    }
  }




}