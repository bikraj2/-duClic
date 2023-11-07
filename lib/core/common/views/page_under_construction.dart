import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:sikshya/core/common/widgets/gradient_background.dart';
import 'package:sikshya/core/res/media_res.dart';

class PageUnderConstruction extends StatefulWidget {
  const PageUnderConstruction({super.key});

  @override
  State<PageUnderConstruction> createState() => _PageUnderConstructionState();
}

class _PageUnderConstructionState extends State<PageUnderConstruction> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
        img: MediaRes.gradientBackground,
        child: SafeArea(
          child: Center(
            child: RiveAnimation.asset(MediaRes.notFound),
          ),
        ),
      ),
    );
  }
}
