import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationBuilder extends StatelessWidget {
  const LottieAnimationBuilder({
    super.key,
    required this.weatherCode,
  });

  final int weatherCode;

  @override
  Widget build(BuildContext context) {
    String animationAsset;

    // Define animations based on weather condition codes
    if (weatherCode == 1003) {
      animationAsset = 'assets/cloudy.json';
    } else if (weatherCode >= 1000 && weatherCode < 1003) {
      animationAsset = 'assets/sunny.json';
    } else if (weatherCode >= 1003 && weatherCode < 1006) {
      animationAsset = 'assets/cloudy.json';
    } else {
      animationAsset = 'assets/rainy.json'; // Default animation
    }
    return Lottie.asset(animationAsset, width: 150, height: 150);
  }
}
