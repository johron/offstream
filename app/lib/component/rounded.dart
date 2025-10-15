import 'package:flutter/material.dart';

class Rounded extends StatelessWidget {
  final Widget child;
  final double radius;

  const Rounded({super.key, required this.child, this.radius = 5.0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: child,
    );
  }
}