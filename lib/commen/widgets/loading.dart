import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: LoadingAnimationWidget.discreteCircle(
            color: Theme.of(context).colorScheme.primary,
            secondRingColor: Theme.of(context).colorScheme.secondary,
            thirdRingColor: Theme.of(context).colorScheme.tertiary,
            size: 56,
          ),
        ),
      ),
    );
  }
}
