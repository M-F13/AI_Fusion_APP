// import 'dart:developer';
//
// import 'package:appwrite/appwrite.dart';
//
// import '../helper/global.dart';
//
// class AppWrite {
//   static final _client = Client();
//   static final _database = Databases(_client);
//
//   static void init() {
//     _client
//         .setEndpoint('https://cloud.appwrite.io/v1')
//         // this is my own
//         // .setProject('66b73c2500013c92e8e9')
//
//         // this is pre written
//         .setProject('658813fd62bd45e744cd')
//         .setSelfSigned(status: true);
//     getApiKey();
//   }
//
//   static Future<String> getApiKey() async {
//     try {
//       final d = await _database.getDocument(
//           databaseId: 'FYP_Database',
//           collectionId: 'ApiKey',
//           documentId: 'chatGptKey');
//
//       apiKey = d.data['apiKey'];
//       log(apiKey);
//       return apiKey;
//     } catch (e) {
//       log('$e');
//       return '';
//     }
//   }
// }
