import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/image_path.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/feature/auth/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  final List<OnboardingData> _onboardingPages = [
    // OnboardingData(
    //   imageUrl: ImagePath.onboardingImg1,
    //   title: 'WHERE AI MEETS THE GAME',
    //   description: 'Experience real-time predictions, insightful analysis, and smarter insights for every match.',
    // ),
    // OnboardingData(
    //   imageUrl: ImagePath.onboardingImg2,
    //   title: 'WHERE AI MEETS THE GAME',
    //   description: 'Experience real-time predictions, insightful analysis, and smarter insights for every match.',
    // ),
    OnboardingData(
      imageUrl: ImagePath.onboardingImg3,
      title: 'WHERE AI MEETS THE GAME',
      description: 'Experience real-time predictions, insightful analysis, and smarter insights for every match.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Pre-cache all images so transitions are instant
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var page in _onboardingPages) {
        precacheImage(AssetImage(page.imageUrl), context);
      }
    });

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_currentPage < _onboardingPages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Get.off(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Prevents white flicker
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemCount: _onboardingPages.length,
        itemBuilder: (context, index) {
          final data = _onboardingPages[index];

          return Stack(
            children: [
              /// --------------------------
              ///  Smooth Fade Image
              /// --------------------------
              Positioned.fill(
                child: FadeImage(data.imageUrl),
              ),

              /// Bottom Gradient Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.95),
                      ],
                    ),
                  ),
                ),
              ),

              /// Text + Swipe Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.title,
                          style: STextTheme.headLineBold().copyWith(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SwipeToStartButton(onComplete: _navigateToHome),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// ----------------------------------------------------------------------
///  Fade Image Widget (No flicker, smooth transition)
/// ----------------------------------------------------------------------
class FadeImage extends StatelessWidget {
  final String imagePath;
  const FadeImage(this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(imagePath),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (_, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// Data Model
class OnboardingData {
  final String imageUrl;
  final String title;
  final String description;
  OnboardingData({required this.imageUrl, required this.title, required this.description});
}

/// Swipe Button
class SwipeToStartButton extends StatefulWidget {
  final VoidCallback onComplete;
  const SwipeToStartButton({super.key, required this.onComplete});

  @override
  State<SwipeToStartButton> createState() => _SwipeToStartButtonState();
}

class _SwipeToStartButtonState extends State<SwipeToStartButton> {
  double _dragPercent = 0.0;
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.85;
    const double buttonHeight = 56;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (_completed) return;

        setState(() {
          _dragPercent += details.delta.dx / width;
          _dragPercent = _dragPercent.clamp(0.0, 1.0);
        });
      },
      onHorizontalDragEnd: (_) {
        if (_dragPercent > 0.7) {
          setState(() => _completed = true);
          Future.delayed(const Duration(milliseconds: 300), widget.onComplete);
        } else {
          setState(() => _dragPercent = 0.0);
        }
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: width,
            height: buttonHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF005F43),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(width: 60),
                Text(
                  "Swipe to start",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
          Positioned(
            left: _dragPercent * (width - buttonHeight),
            child: Container(
              width: buttonHeight,
              height: buttonHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Color(0xFF005F43),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
