import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:my_groovy_recipes/constants/image_paths.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:transparent_image/transparent_image.dart';

class NetworkImageWithLoadingAnimation extends StatelessWidget {
  final String imageUrl;
  final String loadingAnimationPath;

  const NetworkImageWithLoadingAnimation(
      {super.key, required this.imageUrl, required this.loadingAnimationPath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Placeholder widget with Lottie animation
        Lottie.asset(
          loadingAnimationPath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        // Actual network image loaded using FadeInImage
        FadeInImage.memoryNetwork(
          placeholder:
              kTransparentImage, // Transparent placeholder while loading
          image: imageUrl,
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
