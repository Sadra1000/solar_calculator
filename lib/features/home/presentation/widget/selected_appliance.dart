// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
      height: 1.w > 1.h ? 5.w : 7.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.tertiaryContainer,
      ),
      child: Row(
        children: [
          Spacer(flex: 1),
          Expanded(flex: 2, child: FittedBox(child: Icon(icon))),
          Expanded(
            flex: 24,
            child: Row(
              children: [
                // متن نام
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: theme.textTheme.labelSmall,
                ),

                // فاصله کوچک بین دو متن
                SizedBox(width: 2.w),

                // متن توان کل
                Text(
                  'توان کل: ${totalWh.toString().toWhPersian()} ',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: _QuantityController(
              count: count,
              onAdd: onAdd,
              onRemoveOne: onRemoveOne,
              onRemoveAll: onRemoveAll,
            ),
          ),
        ],
      ),
    );
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
                tooltip: 'افزودن یکی',
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
