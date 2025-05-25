

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../helper/global.dart';
import '../model/home_type.dart';

class HomeCard extends StatelessWidget {
  final HomeType homeType;

  const HomeCard({super.key, required this.homeType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Animate.restartOnHotReload = true;

    // Check if this is Image Generator or OCR Scanner card
    final isSwappedLayout = homeType == HomeType.aiImage || homeType == HomeType.aiOCR;
    return Container(
      margin: EdgeInsets.only(bottom: mq.height * 0.02),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: homeType.onTap,
          child: Container(
            height: mq.height * 0.18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              /*This is the gradient which can be modified*/

              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                  // Dark mode colors - blue dominant with subtle purple
                  Colors.blue.shade900.withOpacity(0.8),
                  Colors.indigo.shade800.withOpacity(0.8),
                ]
                    : [
                  // Light mode colors - soft blue with lavender accent
                  Colors.blue.shade50.withOpacity(0.9),
                  Colors.lightBlue.shade100.withOpacity(0.9),
                ],
              ),

              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: isDark
              //       ? [
              //     Colors.blue.shade900,
              //     Colors.purple.shade900,
              //   ]
              //       : [
              //     Colors.blue.shade100,
              //     Colors.purple.shade100,
              //   ],
              // ),

              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: isDark
              //       ? [
              //     Colors.blue.shade900,
              //     Colors.indigo.shade800,
              //     Colors.deepPurple.shade800,
              //   ]
              //       : [
              //     Colors.blue.shade50,
              //     Colors.lightBlue.shade100,
              //     Colors.blue.shade100,
              //   ],
              // ),


            ),
            child: Row(
              children: [
                // Lottie animation on left for swapped cards
                if (isSwappedLayout) ...[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Lottie.asset(
                        'assets/lottie/${homeType.lottie}',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],

                // Text content
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isSwappedLayout
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeType.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.blue.shade900,
                          ),
                          textAlign: isSwappedLayout ? TextAlign.end : TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),

                // Lottie animation on right for normal cards
                if (!isSwappedLayout) ...[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Lottie.asset(
                        'assets/lottie/${homeType.lottie}',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ).animate()
          .fadeIn(duration: 500.ms)
          .slideX(
        begin: isSwappedLayout ? -0.1 : 0.1,
        end: 0,
        duration: 500.ms,
      ),
    );
  }
}