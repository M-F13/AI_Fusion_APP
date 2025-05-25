import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/feature/chatbot_feature.dart';
import '../screen/feature/image_feature.dart';
import '../screen/feature/translator_feature.dart';
import '../screen/feature/ocr_feature.dart';

enum HomeType { aiChatBot, aiImage, aiTranslator, aiOCR }

extension MyHomeType on HomeType {
  //title
  String get title => switch (this) {
    HomeType.aiChatBot => 'AI ChatBot',
    HomeType.aiImage => 'AI Image Generator',
    HomeType.aiTranslator => 'Language Translator',
    HomeType.aiOCR => 'OCR Scanner',
  };

  //subtitle - ADD THIS SECTION
  String get subtitle => switch (this) {
    HomeType.aiChatBot => 'Chat with AI using smart replies',
    HomeType.aiImage => 'Generate images from your imagination',
    HomeType.aiTranslator => 'Translate text between languages',
    HomeType.aiOCR => 'Scan and extract text from images',
  };

  //lottie
  String get lottie => switch (this) {
    HomeType.aiChatBot => 'animation2.json',
    HomeType.aiImage => 'ai_hand_waving.json',
    HomeType.aiTranslator => 'ai_ask_me.json',
    HomeType.aiOCR => 'image_scanning.json',
  };

  //for alignment
  bool get leftAlign => switch (this) {
    HomeType.aiChatBot => true,
    HomeType.aiImage => false,
    HomeType.aiTranslator => true,
    HomeType.aiOCR => false,
  };

  //for padding
  EdgeInsets get padding => switch (this) {
    HomeType.aiChatBot => EdgeInsets.zero,
    HomeType.aiImage => const EdgeInsets.all(20),
    HomeType.aiTranslator => EdgeInsets.zero,
    HomeType.aiOCR => const EdgeInsets.all(20),
  };

  //for navigation
  VoidCallback get onTap => switch (this) {
    HomeType.aiChatBot => () => Get.to(() => ChatBotFeature()),
    HomeType.aiImage => () => Get.to(() => const ImageFeature()),
    HomeType.aiTranslator => () => Get.to(() => const TranslatorFeature()),
    HomeType.aiOCR => () => Get.to(() => OCRScreen()),
    // HomeType.aiOCR => () => Get.to(() => OCRFeature()),
  };
}



void OCRFeature(){}

























// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../screen/feature/chatbot_feature.dart';
// import '../screen/feature/image_feature.dart';
// import '../screen/feature/translator_feature.dart';
// import '../screen/feature/ocr_feature.dart';
//
// enum HomeType { aiChatBot, aiImage, aiTranslator,aiOCR, imageGen, ocr }
//
// extension MyHomeType on HomeType {
//   //title
//   String get title => switch (this) {
//         HomeType.aiChatBot => 'AI ChatBot',
//         HomeType.aiImage => 'AI Image Generator',
//         HomeType.aiTranslator => 'Language Translator',
//         HomeType.aiOCR => 'OCR Scanner',
//       };
//
//   //lottie
//   String get lottie => switch (this) {
//         // HomeType.aiChatBot => 'ai_hand_waving.json',
//         HomeType.aiChatBot => 'animation2.json',
//         // HomeType.aiImage => 'ai_play.json',
//         HomeType.aiImage => 'ai_hand_waving.json',
//         HomeType.aiTranslator => 'ai_ask_me.json',
//         HomeType.aiOCR => 'image_scanning.json',
//       };
//
//   //for alignment
//   bool get leftAlign => switch (this) {
//         HomeType.aiChatBot => true,
//         HomeType.aiImage => false,
//         HomeType.aiTranslator => true,
//         HomeType.aiOCR => false,
//       };
//
//   //for padding
//   EdgeInsets get padding => switch (this) {
//         HomeType.aiChatBot => EdgeInsets.zero,
//         HomeType.aiImage => const EdgeInsets.all(20),
//         HomeType.aiTranslator => EdgeInsets.zero,
//         // HomeType.aiOCR => EdgeInsets.zero,
//         HomeType.aiOCR => const EdgeInsets.all(20),
//       };
//
//
//   //for navigation
//   VoidCallback get onTap => switch (this) {
//         HomeType.aiChatBot => () => Get.to(() => ChatBotFeature()),
//         // HomeType.aiChatBot => () => Get.to(() => const ChatBotFeature()),
//         HomeType.aiImage => () => Get.to(() => const ImageFeature()),
//         HomeType.aiTranslator => () => Get.to(() => const TranslatorFeature()),
//         HomeType.aiOCR => () => Get.to(() => OCRFeature()),
//         // HomeType.aiOCR => () => Get.to(() => const OCRFeature()),
//       };
// }
