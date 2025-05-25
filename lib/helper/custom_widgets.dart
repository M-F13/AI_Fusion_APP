// import 'package:flutter/material.dart';
// import 'asset.dart';
//
//
// class BackgroundImageContainer extends StatelessWidget {
//   final Widget child;
//
//   const BackgroundImageContainer({
//     super.key,
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(AppImagePath.kRectangleBackgound),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: child,
//     );
//   }
// }
//
//
// class CustomRichText extends StatelessWidget {
//   final String title, subtitle;
//   final TextStyle subtitleTextStyle;
//   final VoidCallback onTab;
//
//   const CustomRichText({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.subtitleTextStyle,
//     required this.onTab,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTab,
//       child: RichText(
//         text: TextSpan(
//           text: title,
//           style: const TextStyle(
//               fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
//           children: <TextSpan>[
//             TextSpan(
//               text: subtitle,
//               style: subtitleTextStyle,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class PrimaryButton extends StatefulWidget {
//   final VoidCallback onTap;
//   final String text;
//   final double? width;
//   final double? height;
//   final double? borderRadius;
//   final double? fontSize;
//   final IconData? iconData;
//   final Color? textColor, bgColor;
//
//   const PrimaryButton({
//     Key? key,
//     required this.onTap,
//     required this.text,
//     this.width,
//     this.height,
//     this.borderRadius,
//     this.fontSize,
//     required this.textColor,
//     required this.bgColor,
//     this.iconData,
//   }) : super(key: key);
//
//   @override
//   State<PrimaryButton> createState() => _PrimaryButtonState();
// }
//
// class _PrimaryButtonState extends State<PrimaryButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   final Duration _animationDuration = const Duration(milliseconds: 300);
//   final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
//
//   @override
//   void initState() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: _animationDuration,
//     )..addListener(() {
//       setState(() {});
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _controller.forward().then((_) {
//           _controller.reverse();
//         });
//         widget.onTap();
//       },
//       child: ScaleTransition(
//         scale: _tween.animate(
//           CurvedAnimation(
//             parent: _controller,
//             curve: Curves.easeOut,
//             reverseCurve: Curves.easeIn,
//           ),
//         ),
//         child: Card(
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(widget.borderRadius!),
//           ),
//           child: Container(
//             height: widget.height ?? 55,
//             alignment: Alignment.center,
//             width: widget.width ?? double.maxFinite,
//             decoration: BoxDecoration(
//               color: widget.bgColor,
//               borderRadius: BorderRadius.circular(widget.borderRadius!),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (widget.iconData != null) ...[
//                   Icon(
//                     widget.iconData,
//                     color: AppColor.kWhiteColor,
//                   ),
//                   const SizedBox(width: 4),
//                 ],
//                 Text(
//                   widget.text,
//                   style: TextStyle(
//                     color: widget.textColor,
//                     fontSize: widget.fontSize ?? 14,
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
