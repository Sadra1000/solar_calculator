import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key, required this.msg});
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 24.w,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
