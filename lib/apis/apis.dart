import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:gallery_saver_updated/files.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:http/http. dart' as dotenv;
import 'package:translator_plus/translator_plus.dart';

import '../helper/global.dart';


class APIs {

  // Initialize dotenv (call this once in main.dart)
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }


  // Helper method to get API key
  static String get _apiKey {
    final key = dotenv.env['OPENROUTER_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('OPENROUTER_API_KEY not found in .env file');
    }
    return key;
  }

  // DeepSeek API via OpenRouter
  static Future<String> getAnswer(String question) async {
    try {
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['OPENROUTER_API_KEY']}',
          'Content-Type': 'application/json',
          // 'HTTP-Referer': 'http://localhost',
          'HTTP-Referer': 'https://com.maheen.fyp',
          'X-Title': 'AI Fusion',
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-chat-v3-0324',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant. Respond in English by default. '
                  'Only respond in another language if explicitly requested by the user. '
                  'Ensure all responses are clear, professional, and free of formatting errors.'
            },
            {'role': 'user', 'content': question}
          ],
          'temperature': 0.5, // Reduced for more focused responses
          'max_tokens': 500, // Reduced for faster responses
          // 'stream': false,     // Ensure complete response before returning
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        throw 'API Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      throw 'Failed to get response: ${e.toString()}';
    }
  }


  // static Future<String> getAnswer(String question) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
  //       headers: {
  //         'Authorization': 'Bearer ${apiKey}',
  //         'Content-Type': 'application/json',
  //         'HTTP-Referer': 'http://localhost',
  //         'X-Title': 'AI Fusion',
  //       },
  //       body: jsonEncode({
  //         'model': 'deepseek/deepseek-chat', // Faster model
  //         'messages': [
  //           {
  //             'role': 'system',
  //             'content': 'Respond in clean plain text without special characters. '
  //                 'Use English unless asked otherwise. Be concise.'
  //           },
  //           {'role': 'user', 'content': question}
  //         ],
  //         'temperature': 0.3, // More focused responses
  //         'max_tokens': 500,  // Faster generation
  //         'stream': false,
  //       }),
  //     ).timeout(Duration(seconds: 10)); // Timeout after 10 seconds
  //
  //     if (response.statusCode == 200) {
  //       String answer = jsonDecode(response.body)['choices'][0]['message']['content'];
  //       // Clean up response
  //       return answer
  //           .replaceAll('**', '')
  //           .replaceAll('*', '')
  //           .replaceAll('`', '')
  //           .replaceAll(RegExp(r'\s+'), ' ')
  //           .trim();
  //     }
  //     return 'Error: API response failed';
  //   } catch (e) {
  //     return 'Error: ${e.toString().replaceAll('Exception: ', '')}';
  //   }
  // }


  // static Future<String> getAnswer(String question) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
  //       headers: {
  //         'Authorization': 'Bearer ${apiKey}',
  //         'Content-Type': 'application/json',
  //         'HTTP-Referer': 'http://localhost',
  //         'X-Title': 'AI Fusion',
  //       },
  //       body: jsonEncode({
  //         'model': 'deepseek/deepseek-chat-v3-0324',
  //         'messages': [
  //           {
  //             'role': 'system',
  //             'content': 'You are a helpful assistant. Respond in English by default. '
  //                 'Only respond in another language if explicitly requested by the user. '
  //                 'Ensure all responses are clear, professional, and free of formatting errors.'
  //           },
  //           {'role': 'user', 'content': question}
  //         ],
  //         'temperature': 0.5,  // Reduced for more focused responses
  //         'max_tokens': 500,   // Reduced for faster responses
  //         'stream': false,     // Ensure complete response before returning
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return data['choices'][0]['message']['content'].trim();
  //     } else {
  //       throw 'API Error: ${response.statusCode} - ${response.body}';
  //     }
  //   } catch (e) {
  //     throw 'Failed to get response: ${e.toString()}';
  //   }
  // }

  // //get answer from chat gpt
  // static Future<String> getAnswer(String question) async {
  //   try {
  //     //
  //     final res =
  //         await post(Uri.parse('https://api.openai.com/v1/chat/completions'),
  //
  //             //headers
  //             headers: {
  //               HttpHeaders.contentTypeHeader: 'application/json',
  //               HttpHeaders.authorizationHeader: 'Bearer $apiKey'
  //             },
  //
  //             //body
  //             body: jsonEncode({
  //               "model": "gpt-3.5-turbo",
  //               "max_tokens": 2000,
  //               "temperature": 0,
  //               "messages": [
  //                 {"role": "user", "content": question},
  //               ]
  //             }));
  //
  //     final data = jsonDecode(res.body);
  //
  //     log('res: $data');
  //     return data['choices'][0]['message']['content'];
  //   } catch (e) {
  //     log('getAnswerE: $e');
  //     return 'Something went wrong (Try again in sometime)';
  //   }
  // }


  // Image Generator API key
  // Stable Horde API (free) - Add your API key here
  static const String _shapiKey = "7NDPFLpwT2OFRAVyrgeMBw";
  static const String _baseUrl = "https://stablehorde.net/api/v3";

  static Future<Uint8List?> generateImage(String prompt) async {
    try {
      // 1. Submit job
      final response = await http.post(
        Uri.parse('$_baseUrl/generate/async'),
        headers: {
          'Content-Type': 'application/json',
          'apikey': _shapiKey,
          'Client-Agent': 'ai-fusion-app/1.0',
        },
        body: jsonEncode({
          "prompt": "$prompt (4K, best quality)",
          "params": {
            "width": 512,
            "height": 512,
            "steps": 25,
            "sampler_name": "k_euler_a",
          },
          "nsfw": false,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 202) {
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }

      final jobId = jsonDecode(response.body)['id'];
      log('Job submitted: $jobId');

      // 2. Poll for completion
      final result = await _pollJob(jobId);
      if (result == null) throw Exception('Job failed');

      // 3. Download image
      final imageResponse = await http.get(Uri.parse(result));
      return imageResponse.bodyBytes;
    } catch (e) {
      log('Generation failed: $e');
      return null;
    }
  }

  static Future<String?> _pollJob(String jobId) async {
    int attempts = 0;
    while (attempts < 20) {
      await Future.delayed(const Duration(seconds: 3));
      attempts++;

      try {
        final status = await http.get(
          Uri.parse('$_baseUrl/generate/check/$jobId'),
          headers: {'apikey': _shapiKey},
        );

        final statusData = jsonDecode(status.body);
        if (statusData['done'] == true) {
          final result = await http.get(
            Uri.parse('$_baseUrl/generate/status/$jobId'),
            headers: {'apikey': _shapiKey},
          );
          return jsonDecode(result.body)['generations'][0]['img'];
        }
      } catch (e) {
        log('Polling error: $e');
      }
    }
    return null;
  }


  // Language Tranlator API
  static Future<Map<String, String?>> googleTranslateWithDetection({
    required String from,
    required String to,
    required String text,
  }) async {
    try {
      final translation = await GoogleTranslator().translate(
          text, from: from, to: to);

      String? detectedLanguage = '';
      if (from == 'auto') {
        detectedLanguage = translation.sourceLanguage.code;
      }


      return {
        'translation': translation.text,
        'detectedLanguage': detectedLanguage,
      };
    } catch (e) {
      log('googleTranslateE: $e');
      return {
        'translation': null,
        'detectedLanguage': null,
      };
    }
  }
}





