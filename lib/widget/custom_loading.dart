// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
//
// class CustomLoading extends StatelessWidget {
//   const CustomLoading({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Lottie.asset('assets/lottie/loading.json', width: 100);
//   }
// }




import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Lottie.asset(
            'assets/lottie/loading.json',
            width: 150,
          ),
        ),
      ),
    );
  }
}