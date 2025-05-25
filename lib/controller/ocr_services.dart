import 'dart:io';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class OcrController extends GetxController {
  // Reactive variables
  final pickedImagePath = ''.obs;
  final recognizedText = ''.obs;
  final isLoading = false.obs;
  final isDownloadingData = false.obs;
  final ocrReady = false.obs;

  // Dependencies
  final ImagePicker _picker = ImagePicker();
  final http.Client _httpClient = http.Client();

  @override
  void onInit() {
    super.onInit();
    _initializeTesseract();
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }

  void checkTrainedDataAsset() async {
    try {
      final data = await rootBundle.load('assets/tessdata/eng.traineddata');
      log("✅ Trained data loaded successfully, size: ${data.lengthInBytes} bytes");
    } catch (e) {
      log("❌ Error loading traineddata asset: $e");
    }
  }


  Future<void> _initializeTesseract() async {
    try {
      await _verifyOrDownloadTessData();
      ocrReady.value = true;
    } catch (e) {
      recognizedText.value = 'OCR initialization failed: ${e.toString()}';
      log('Tesseract init error: $e');
    }
  }

  Future<void> _verifyOrDownloadTessData() async {
    // First try loading from assets
    try {
      await rootBundle.load('assets/tessdata/eng.traineddata');
      log('Tesseract data loaded from assets');
      return;
    } catch (_) {}

    // Fallback to download if asset loading fails
    isDownloadingData.value = true;
    try {
      await _downloadTessData();
    } finally {
      isDownloadingData.value = false;
    }
  }

  Future<void> _downloadTessData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw 'No internet connection';
    }

    final dir = await getApplicationDocumentsDirectory();
    final tessdataDir = Directory('${dir.path}/tessdata');

    if (!await tessdataDir.exists()) {
      await tessdataDir.create(recursive: true);
    }

    final trainedDataFile = File('${tessdataDir.path}/eng.traineddata');
    const url = 'https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata';

    try {
      final response = await _httpClient.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw 'Download failed (HTTP ${response.statusCode})';
      }

      await trainedDataFile.writeAsBytes(response.bodyBytes);
      log('Downloaded Tesseract data (${response.bodyBytes.length} bytes)');
    } catch (e) {
      if (await trainedDataFile.exists()) {
        await trainedDataFile.delete();
      }
      throw 'Download failed: $e';
    }
  }

  // Image picking methods
  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        await _processImageFile(pickedFile);
      }
    } catch (e) {
      _handleError('Image selection', e);
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        await _processImageFile(pickedFile);
      }
    } catch (e) {
      _handleError('Image capture', e);
    }
  }

  Future<void> _processImageFile(XFile imageFile) async {
    if (!ocrReady.value) {
      recognizedText.value = 'OCR engine not ready';
      return;
    }

    isLoading.value = true;
    pickedImagePath.value = imageFile.path;
    recognizedText.value = '';

    try {
      final processedImagePath = await _preprocessImage(imageFile.path);
      final tessdataDirPath = '${(await getApplicationDocumentsDirectory()).path}/tessdata';
      final exists = await File('$tessdataDirPath/eng.traineddata').exists();
      if (!exists) throw 'Tessdata file not found at $tessdataDirPath';

      final text = await FlutterTesseractOcr.extractText(
        processedImagePath,
        language: 'eng',
        args: {
          "psm": "6",
          "oem": "1",
          "preserve_interword_spaces": "1",
          // "tessdata": tessdataDirPath,  // ✅ Explicit path
        },
      );


      recognizedText.value = text.trim().isEmpty ? 'No text recognized' : text;
    } catch (e, stack) {
      _handleError('OCR processing', e, stack);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _preprocessImage(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      var image = img.decodeImage(bytes);
      if (image == null) throw 'Failed to decode image';

      // Image processing pipeline
      image = img.grayscale(image);
      image = img.adjustColor(image, contrast: 1.5);
      image = img.gaussianBlur(image, radius: 1);

      // Save processed image
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.png';
      await File(outputPath).writeAsBytes(img.encodePng(image));

      return outputPath;
    } catch (e) {
      log('Image processing error, using original: $e');
      return imagePath;
    }
  }

  Future<void> checkAsset() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/tessdata/eng.traineddata');
    final exists = await file.exists();
    log('Tessdata exists: $exists at ${file.path}');
    recognizedText.value = exists
        ? 'Tesseract data exists at: ${file.path}'
        : 'Tesseract data not found!';
  }

  void _handleError(String context, dynamic error, [StackTrace? stack]) {
    final errorMsg = 'Error during $context: ${error.toString()}';
    recognizedText.value = errorMsg;
    log(errorMsg, stackTrace: stack);
  }
}