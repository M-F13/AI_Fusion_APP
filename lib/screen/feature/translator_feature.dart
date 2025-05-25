// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../controller/image_controller.dart';
// import '../../controller/translate_controller.dart';
// import '../../helper/global.dart';
// import '../../widget/custom_btn.dart';
// import '../../widget/custom_loading.dart';
// import '../../widget/language_sheet.dart';
//
// class TranslatorFeature extends StatefulWidget {
//   const TranslatorFeature({super.key});
//
//   @override
//   State<TranslatorFeature> createState() => _TranslatorFeatureState();
// }
//
// class _TranslatorFeatureState extends State<TranslatorFeature> {
//   final _c = TranslateController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //app bar
//       appBar: AppBar(
//         title: const Text('Multi Language Translator'),
//       ),
//
//       //body
//       body: ListView(
//         physics: const BouncingScrollPhysics(),
//         padding: EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .1),
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             //from language
//             InkWell(
//               onTap: () => Get.bottomSheet(LanguageSheet(c: _c, s: _c.from)),
//               borderRadius: const BorderRadius.all(Radius.circular(15)),
//               child: Container(
//                 height: 50,
//                 width: mq.width * .4,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.blue),
//                     borderRadius: const BorderRadius.all(Radius.circular(15))),
//                 child:
//                     Obx(() => Text(_c.from.isEmpty ? 'Auto' : _c.from.value)),
//               ),
//             ),
//
//             //swipe language btn
//             IconButton(
//                 onPressed: _c.swapLanguages,
//                 icon: Obx(
//                   () => Icon(
//                     CupertinoIcons.repeat,
//                     color: _c.to.isNotEmpty && _c.from.isNotEmpty
//                         ? Colors.blue
//                         : Colors.grey,
//                   ),
//                 )),
//
//             //to language
//             InkWell(
//               onTap: () => Get.bottomSheet(LanguageSheet(c: _c, s: _c.to)),
//               borderRadius: const BorderRadius.all(Radius.circular(15)),
//               child: Container(
//                 height: 50,
//                 width: mq.width * .4,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.blue),
//                     borderRadius: const BorderRadius.all(Radius.circular(15))),
//                 child: Obx(() => Text(_c.to.isEmpty ? 'To' : _c.to.value)),
//               ),
//             ),
//           ]),
//
//           //text field
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: mq.width * .04, vertical: mq.height * .035),
//             child: TextFormField(
//               controller: _c.textC,
//               minLines: 5,
//               maxLines: null,
//               onTapOutside: (e) => FocusScope.of(context).unfocus(),
//               decoration: const InputDecoration(
//                   hintText: 'Translate anything you want...',
//                   hintStyle: TextStyle(fontSize: 13.5),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)))),
//             ),
//           ),
//
//           //result field
//           Obx(() => _translateResult()),
//
//           //for adding some space
//           SizedBox(height: mq.height * .04),
//
//           //translate btn
//           CustomBtn(
//             onTap: _c.googleTranslate,
//             // onTap: _c.translate,
//             text: 'Translate',
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _translateResult() => switch (_c.status.value) {
//         Status.none => const SizedBox(),
//         Status.complete => Padding(
//             padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
//             child: TextFormField(
//               controller: _c.resultC,
//               maxLines: null,
//               onTapOutside: (e) => FocusScope.of(context).unfocus(),
//               decoration: const InputDecoration(
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)))),
//             ),
//           ),
//         Status.loading => const Align(child: CustomLoading())
//       };
// }

















import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/image_controller.dart';
import '../../controller/translate_controller.dart';
import '../../helper/custom_app_bar.dart';
import '../../helper/global.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_loading.dart';
import '../../widget/language_sheet.dart';

class TranslatorFeature extends StatefulWidget {
  const TranslatorFeature({super.key});

  @override
  State<TranslatorFeature> createState() => _TranslatorFeatureState();
}

class _TranslatorFeatureState extends State<TranslatorFeature> {
  final _c = TranslateController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: CustomAppBar(
        title:  ('Multi Language Translator'),
      ),

      // Body
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .1),
        children: [
          // Language Selection Row
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // From Language
            InkWell(
              onTap: () => Get.bottomSheet(LanguageSheet(c: _c, s: _c.from)),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Container(
                height: 50,
                width: mq.width * .4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Obx(() => Text(
                  _c.from.isEmpty
                      ? (_c.detectedSourceLang.isEmpty
                      ? 'Auto Detect'
                      : '${_c.detectedSourceLang} (Detected)')
                      : _c.from.value,
                  style: TextStyle(
                    color: _c.from.isEmpty ? Colors.grey : Colors.black,
                  ),
                )),
              ),
            ),

            // Swap Languages Button
            IconButton(
                onPressed: _c.swapLanguages,
                icon: Obx(
                      () => Icon(
                    CupertinoIcons.repeat,
                    color: _c.to.isNotEmpty && _c.from.isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
                  ),
                )),

            // To Language
            InkWell(
              onTap: () => Get.bottomSheet(LanguageSheet(c: _c, s: _c.to)),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Container(
                height: 50,
                width: mq.width * .4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Obx(() => Text(_c.to.value)),
              ),
            ),
          ]),

          // Text Input Field
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .035),
            child: TextFormField(
              controller: _c.textC,
              minLines: 5,
              maxLines: null,
              onTapOutside: (e) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                  hintText: 'Translate anything you want...',
                  hintStyle: TextStyle(fontSize: 13.5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
          ),

          // Translation Result Field
          Obx(() => _translateResult()),

          // Spacer
          SizedBox(height: mq.height * .04),

          // Translate Button
          CustomBtn(
            onTap: _c.googleTranslate,
            text: 'Translate',
          )
        ],
      ),
    );
  }

  // Widget to Display Translation Result
  Widget _translateResult() => switch (_c.status.value) {
    Status.none => const SizedBox(),
    Status.complete => Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
      child: TextFormField(
        controller: _c.resultC,
        maxLines: null,
        onTapOutside: (e) => FocusScope.of(context).unfocus(),
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    ),
    Status.loading => const Align(child: CustomLoading())
  };
}













