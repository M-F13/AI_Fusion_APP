import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../helper/global.dart';
import '../model/onboard.dart';
import '../widget/custom_btn.dart';
import 'login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int currentPage = 0;

  final onboardingList = [
    Onboard(
      title: 'Ask Me Anything',
      subtitle: 'Your AI-powered assistant ready to help 24/7 with instant answers to all your questions',
      lottie: 'ai_ask_me',
    ),
    Onboard(
      title: 'Imagination to Reality',
      subtitle: 'Transform your ideas into stunning visuals with our advanced AI generation technology',
      lottie: 'ai_play',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                    Colors.blueGrey.shade900.withOpacity(0.8),
                    Colors.indigo.shade900.withOpacity(0.8),
                  ]
                      : [
                    Colors.blue.shade50,
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // Decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withOpacity(0.1),
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withOpacity(0.1),
              ),
            ),
          ),

          PageView.builder(
            controller: controller,
            itemCount: onboardingList.length,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, index) {
              final onboard = onboardingList[index];
              final isLast = index == onboardingList.length - 1;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.08),
                child: Column(
                  children: [
                    SizedBox(height: mq.height * 0.1),

                    // Animated Tech Border
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade300,
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          color: theme.cardColor,
                          padding: const EdgeInsets.all(20),
                          child: Lottie.asset(
                            'assets/lottie/${onboard.lottie}.json',
                            height: mq.height * 0.3,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),

                    SizedBox(height: mq.height * 0.05),

                    // Title with tech-inspired gradient
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.purple.shade300,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        onboard.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(height: mq.height * 0.03),

                    // Subtitle with animated entry
                    Text(
                      onboard.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
                        height: 1.6,
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

                    const Spacer(),

                    // Tech-inspired dots indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingList.length,
                            (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: i == currentPage ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == currentPage
                                ? theme.primaryColor
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: i == currentPage
                                ? [
                              BoxShadow(
                                color: theme.primaryColor.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                                : null,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: mq.height * 0.04),

                    // Animated button with tech glow
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: 300.ms,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.purple.shade300,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade400.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              if (isLast) {
                                Get.off(() => const LoginPage());
                              } else {
                                controller.nextPage(
                                  duration: 600.ms,
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 32,
                              ),
                              child: Text(
                                isLast ? 'Get Started' : 'Next',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).animate().scale(delay: 300.ms),
                    ),

                    SizedBox(height: mq.height * 0.05),
                  ],
                ),
              );
            },
          ),

          // Skip button
          Positioned(
            top: mq.height * 0.06,
            right: mq.width * 0.08,
            child: TextButton(
              onPressed: () => Get.off(() => const LoginPage()),
              child: Text(
                'Skip',
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}