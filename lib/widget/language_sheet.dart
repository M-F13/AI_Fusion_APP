// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controller/translate_controller.dart';
// import '../helper/global.dart';
//
// class LanguageSheet extends StatefulWidget {
//   final TranslateController c;
//   final RxString s;
//
//   const LanguageSheet({super.key, required this.c, required this.s});
//
//   @override
//   State<LanguageSheet> createState() => _LanguageSheetState();
// }
//
// class _LanguageSheetState extends State<LanguageSheet> {
//   final _search = ''.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: mq.height * .5,
//       padding: EdgeInsets.only(
//           left: mq.width * .04, right: mq.width * .04, top: mq.height * .02),
//       decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(15), topRight: Radius.circular(15))),
//       child: Column(
//         children: [
//           TextFormField(
//             // controller: _c.resultC,
//             onChanged: (s) => _search.value = s.toLowerCase(),
//
//             onTapOutside: (e) => FocusScope.of(context).unfocus(),
//             decoration: const InputDecoration(
//                 prefixIcon: Icon(Icons.translate_rounded, color: Colors.blue),
//                 hintText: 'Search Language...',
//                 hintStyle: TextStyle(fontSize: 14),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10)))),
//           ),
//
//           //
//           Expanded(
//             child: Obx(
//               () {
//                 final List<String> list = _search.isEmpty
//                     ? widget.c.lang
//                     : widget.c.lang
//                         .where((e) => e.toLowerCase().contains(_search.value))
//                         .toList();
//
//                 return ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: list.length,
//                   padding: EdgeInsets.only(top: mq.height * .02, left: 6),
//                   itemBuilder: (ctx, i) {
//                     return InkWell(
//                       onTap: () {
//                         widget.s.value = list[i];
//                         log(list[i]);
//                         Get.back();
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.only(bottom: mq.height * .02),
//                         child: Text(list[i]),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

















import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/translate_controller.dart';
import '../helper/global.dart';

class LanguageSheet extends StatefulWidget {
  final TranslateController c;
  final RxString s;

  const LanguageSheet({super.key, required this.c, required this.s});

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  final _search = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * .5,
      padding: EdgeInsets.only(
          left: mq.width * .04, right: mq.width * .04, top: mq.height * .02),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        children: [
          // Search Bar
          TextFormField(
            onChanged: (s) => _search.value = s.toLowerCase(),
            onTapOutside: (e) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.translate_rounded, color: Colors.blue),
                hintText: 'Search Language...',
                hintStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),

          // Language List
          Expanded(
            child: Obx(
                  () {
                // Add "Auto Detect" to the list
                final List<String> list = _search.isEmpty
                    ? ['Auto Detect', ...widget.c.lang] // Include "Auto Detect"
                    : widget.c.lang
                    .where((e) => e.toLowerCase().contains(_search.value))
                    .toList();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: mq.height * .02, left: 6),
                  itemBuilder: (ctx, i) {
                    return InkWell(
                      onTap: () {
                        // If "Auto Detect" is selected, set the value to an empty string
                        widget.s.value = list[i] == 'Auto Detect' ? '' : list[i];
                        log(list[i]);
                        Get.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: mq.height * .02),
                        child: Text(
                          list[i],
                          style: TextStyle(
                            color: list[i] == 'Auto Detect'
                                ? Colors.blue // Highlight "Auto Detect"
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}