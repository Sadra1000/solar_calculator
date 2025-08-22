// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:solar_calculator/commen/constants.dart';

import 'package:solar_calculator/commen/helpers/persian.dart';

class GroupCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final int count;
  final int totalWh;
  final VoidCallback onAdd;
  final VoidCallback onRemoveOne;
  final VoidCallback onRemoveAll;

  const GroupCard({
    super.key,
    required this.icon,
    required this.name,
    required this.count,
    required this.totalWh,
    required this.onAdd,
    required this.onRemoveOne,
    required this.onRemoveAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.tertiaryContainer,
      ),
      child: LayoutBuilder(
        builder:
            (_, box) => AspectRatio(
              aspectRatio: calculateAR(box.maxWidth),
              child: Row(
                children: [
                  Expanded(flex: 1, child: SizedBox.shrink()),
                  Expanded(flex: 4, child: FittedBox(child: Icon(icon))),
                  Expanded(flex: 1, child: SizedBox.shrink()),

                  Expanded(
                    flex: 10,
                    child: FittedBox(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  Expanded(flex: 1, child: SizedBox.shrink()),
                  Expanded(
                    flex: 10,
                    child: FittedBox(
                      child: Text(
                        'توان کل: ${totalWh.toString().toWhPersian()} ',
                      ),
                    ),
                  ),
                  Expanded(flex: 33, child: SizedBox.shrink()),

                  Expanded(
                    flex: 14,
                    child: _QuantityController(
                      count: count,
                      onAdd: onAdd,
                      onRemoveOne: onRemoveOne,
                      onRemoveAll: onRemoveAll,
                    ),
                  ),
                  Expanded(flex: 1, child: SizedBox.shrink()),
                ],
              ),
            ),
      ),
    );
  }

  double calculateAR(double b) {
    if (b >= Constants.kDesktopBreakpoint) {
      // Desktop Layout (and very large tablets in landscape)
      return 10 / 0.36;
    } else if (b >= Constants.kPhoneBreakpoint) {
      // Tablet Layout (and large phones in landscape)
      return 10 / 0.56;
    } else {
      return 10 / 0.8;
    }
  }
}

class _QuantityController extends StatelessWidget {
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemoveOne;
  final VoidCallback onRemoveAll;

  const _QuantityController({
    required this.count,
    required this.onAdd,
    required this.onRemoveOne,
    required this.onRemoveAll,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // دکمه + (TextButton با استایل M3)
        Expanded(
          flex: 1,
          child: FittedBox(
            child: FittedBox(
              child: IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                tooltip: 'افزودن کردن یکی',
              ),
            ),
          ),
        ),

        // تعداد به فارسی
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(7),
            child: FittedBox(child: Text(count.toString().toPersianDigits())),
          ),
        ),

        Expanded(flex: 1, child: _builbtn()),
      ],
    );
  }

  Widget _builbtn() {
    if (count >= 2) {
      return FittedBox(
        child: IconButton(
          onPressed: onRemoveOne,
          icon: const Icon(Icons.remove_circle_outline),
          tooltip: 'کم کردن یکی',
        ),
      );
    } else {
      return FittedBox(
        child: IconButton(
          onPressed: onRemoveAll,
          icon: const Icon(Icons.delete_outline),
          tooltip: 'حذف کامل',
        ),
      );
    }
  }
}
