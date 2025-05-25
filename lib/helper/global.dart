import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//app name
const appName = 'AI Fusion';

//media query to store size of device screen
late Size mq;

String apiKey = dotenv.env['OPENROUTER_API_KEY']!;

// Hugging Face API key
String imageGenApiKey = dotenv.env['IMAGE_GEN']!;

// Hugging Face API key
String replicateApiKey = dotenv.env['REPLICATE_API_KEY']!;

// gemini api key
String api = "AIzaSyCa7bwPrmFFRhetXFOOzLpCsrrXtLK5ZDg";

// String apiKey = '';
