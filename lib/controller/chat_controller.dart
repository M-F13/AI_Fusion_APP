import 'package:flutter/material.dart';
// library package:flutter/ material. dart
import 'package:get/get.dart';

import '../apis/apis.dart';
import '../model/message.dart';






class ChatController extends GetxController {
  final textC = TextEditingController();
  final scrollC = ScrollController();

  // Make all reactive variables observable
  final isLoading = false.obs;
  final messages = <Message>[].obs;
  final hasText = false.obs;

  @override
  void onInit() {
    messages.add(Message(
        msg: 'Hello! How can I assist you today?',
        msgType: MessageType.bot
    ));

    // Listen to text changes
    textC.addListener(() {
      hasText.value = textC.text.trim().isNotEmpty;
    });

    super.onInit();
  }

  Future<void> askQuestion() async {
    if (!hasText.value) return;

    try {
      isLoading(true);
      final question = textC.text.trim();
      messages.add(Message(msg: question, msgType: MessageType.user));
      messages.add(Message(msg: '', msgType: MessageType.bot));

      final response = await APIs.getAnswer(question);

      messages.removeLast();
      messages.add(Message(msg: response, msgType: MessageType.bot));
      textC.clear();
    } catch (e) {
      messages.removeLast();
      messages.add(Message(
          msg: 'Error: ${e.toString()}',
          msgType: MessageType.bot
      ));
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    textC.dispose();
    scrollC.dispose();
    super.onClose();
  }
}





















