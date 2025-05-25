// Or your new package name
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/chat_controller.dart';
import '../../helper/custom_app_bar.dart';
import '../../helper/global.dart';
import '../../widget/message_card.dart';


class ChatBotFeature extends StatelessWidget {
  ChatBotFeature({super.key});
  final _c = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            title: ('AI Assistant'),
    //         actions: [
    //         Obx(() => _c.isLoading.value
    // ? const Padding(
    // padding: EdgeInsets.only(right: 16),
    // child: CircularProgressIndicator(),
    // )
    //     : const SizedBox.shrink(),
    //         )
    //         ],
    ),
    body: Obx(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_c.scrollC.hasClients) {
    _c.scrollC.animateTo(
    _c.scrollC.position.maxScrollExtent,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
    );
    }
    });

    return ListView.builder(
    controller: _c.scrollC,
    physics: const BouncingScrollPhysics(),
    padding: EdgeInsets.only(
    top: mq.height * .02,
    bottom: mq.height * .1,
    left: 8,
    right: 8,
    ),
    itemCount: _c.messages.length,
    itemBuilder: (ctx, i) => MessageCard(message: _c.messages[i]),
    );
    }),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: _buildInputField(),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _c.textC,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: Obx(() => _c.hasText.value
                    ? IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _c.askQuestion,
                )
                    : const SizedBox.shrink(),
                ),
              ),
              onSubmitted: (_) => _c.askQuestion(),
            ),
          ),
        ],
      ),
    );
  }
}














