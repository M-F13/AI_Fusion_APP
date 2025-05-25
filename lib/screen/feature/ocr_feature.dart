import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../controller/ocr_services.dart';
import '../../helper/custom_app_bar.dart';
import '../../widget/custom_btn.dart';

class OCRScreen extends StatefulWidget {
  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  final OcrController _ocrService = Get.find<OcrController>();

  String? _extractedText;
  bool _isLoading = false;
  bool _hasError = false;
  XFile? _selectedImage;

  Future<void> _processImage(Future<void> Function() pickerFunction) async {
    setState(() {
      _isLoading = true;
      _extractedText = null;
      _hasError = false;
    });

    try {
      await pickerFunction();
      setState(() {
        _extractedText = _ocrService.recognizedText.value;
        _selectedImage = _ocrService.pickedImagePath.value.isNotEmpty
            ? XFile(_ocrService.pickedImagePath.value)
            : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _extractedText = "Error processing image: ${e.toString()}";
      });
    }
  }


  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.white,
          ),
          SizedBox(height: 20),
          Container(
            width: 150,
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildResultContent() {
    return Column(
      children: [
        if (_hasError)
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.red[100],
            child: Text(
              'Error occurred during processing',
              style: TextStyle(color: Colors.red),
            ),
          ),
        if (_selectedImage != null)
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Image.file(File(_selectedImage!.path)),
          ),
        SizedBox(height: 10),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: SelectableText(
                _extractedText ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: _hasError ? Colors.red : null,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: _extractedText?.isNotEmpty ?? false
              ? () {
            Clipboard.setData(ClipboardData(text: _extractedText!));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Text copied to clipboard!")),
            );
          }
              : null,
          child: Text('Copy Text', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildPlaceholderContent(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/image_scanning.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16),
          Text(
            'Select an image to extract text',
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          // In your OCRScreen widget
          FloatingActionButton(
            onPressed: () async {
              final controller = Get.find<OcrController>();
              await controller.checkAsset();
            },
            child: Icon(Icons.bug_report),
            tooltip: 'Check Assets',
          )
        ],
      ),
    );
  }

  Widget _buildContentSection(bool isDark) {
    if (_isLoading) {
      return _buildLoadingShimmer();
    } else if (_extractedText != null) {
      return _buildResultContent();
    } else {
      return _buildPlaceholderContent(isDark);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: "OCR Text Recognition"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildContentSection(isDark)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomBtn(
                  text: 'Gallery',
                  onTap: () => _processImage(_ocrService.pickImageFromGallery),
                  icon: Icons.photo_library,
                ),
                CustomBtn(
                  text: 'Camera',
                  onTap: () => _processImage(_ocrService.pickImageFromCamera),
                  icon: Icons.camera_alt,
                ),

              ],
            ),
          ],
        ),
      ),
    );

  }

}

