import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({required this.child, required this.img, super.key});
  final Widget child;
  final String img;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            img,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
