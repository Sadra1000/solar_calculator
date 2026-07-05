import 'package:flutter/material.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';

class CustomError extends StatelessWidget {
  const CustomError({
    super.key,
    required this.msg,
    this.onDismiss,
    this.onRetry,
  });

  final String msg;
  final VoidCallback? onDismiss;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onRetry != null) ...[
                  TextButton(
                    onPressed: onRetry,
                    child: Text(l10n.retry),
                  ),
                  const SizedBox(width: 8),
                ],
                FilledButton(
                  onPressed: onDismiss ?? () => Navigator.of(context).pop(),
                  child: Text(l10n.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
