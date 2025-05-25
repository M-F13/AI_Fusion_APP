import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/global.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon; // Make icon optional

  const CustomBtn({
    super.key,
    required this.onTap,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: isDark
                ? [
              Colors.blue.shade900,
              Colors.indigo.shade800,
            ]
                : [
              Colors.blue.shade200,
              Colors.lightBlue.shade300,
            ],
          ),
        ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: mq.width * .4,
            minHeight: 50,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(icon, color: Colors.white),
              if (icon != null)
                const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}









// import 'package:fyp/main.dart';
// import 'package:flutter/material.dart';
//
// import '../helper/global.dart';
//
// class CustomBtn extends StatelessWidget {
//   final String text;
//   final VoidCallback onTap;
//
//   const CustomBtn({super.key, required this.onTap, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               shape: const StadiumBorder(),
//               elevation: 0,
//               backgroundColor: Theme.of(context).buttonColor,
//               textStyle:
//                   const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               minimumSize: Size(mq.width * .4, 50)),
//           onPressed: onTap,
//           child: Text(text)),
//     );
//   }
// }
