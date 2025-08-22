import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      child: Container(
        width: 20.w,
        height: 30.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: LoadingAnimationWidget.discreteCircle(
            color: Theme.of(context).colorScheme.primary,
            secondRingColor: Theme.of(context).colorScheme.secondary,
            thirdRingColor: Theme.of(context).colorScheme.tertiary,
            size: 15.h,
          ),
        ),
      ),
    );
  }
}
