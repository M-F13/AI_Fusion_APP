import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controller/image_controller.dart';
import '../../helper/custom_app_bar.dart';
import '../../helper/global.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_loading.dart';

class ImageFeature extends StatefulWidget {
  const ImageFeature({super.key});

  @override
  State<ImageFeature> createState() => _ImageFeatureState();
}

class _ImageFeatureState extends State<ImageFeature> {
  final _c = ImageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: CustomAppBar(
        title: 'AI Image Generator',
        actions: [
          Obx(
                () => _c.status.value == Status.complete
                ? IconButton(
                padding: const EdgeInsets.only(right: 6),
                onPressed: _c.shareImage,
                icon: const Icon(Icons.share))
                : const SizedBox(),
          )
        ],
      ),

      //body
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
            top: mq.height * .02,
            bottom: mq.height * .1,
            left: mq.width * .04,
            right: mq.width * .04),
        children: [
          //text field
          TextFormField(
            controller: _c.textC,
            textAlign: TextAlign.center,
            minLines: 2,
            maxLines: null,
            onTapOutside: (e) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: 'Imagine something wonderful & innovative\nType here & I will create for you 😃',
              hintStyle: TextStyle(fontSize: 13.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),

          //ai image container
          Container(
            height: mq.height * .5,
            margin: EdgeInsets.symmetric(vertical: mq.height * .015),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Obx(() => _aiImage()),
          ),

          // Create button - using original CustomBtn without isLoading parameter
          Obx(() => CustomBtn(
            onTap: _c.searchAiImage,
            text: _c.status.value == Status.loading ? 'Creating...' : 'Create',
          )),
        ],
      ),
    );
  }

  // image_feature.dart
  Widget _aiImage() {
    if (_c.status.value == Status.loading) {
      return Lottie.asset(
        'assets/lottie/loading.json',
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      );
    }

    if (_c.imageBytes.value == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/ai_hand_waving.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            'Describe your vision above',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        _c.imageBytes.value! as Uint8List,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}