import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_calculator/commen/helpers/icon_helper.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';

class ApplianceIcon extends StatefulWidget {
  const ApplianceIcon({super.key, required this.catgory});

  final AppliancesCatgory catgory;

  @override
  State<ApplianceIcon> createState() => _ApplianceIconState();
}

class _ApplianceIconState extends State<ApplianceIcon> {
  bool _isPressed = false;

  void _onTap() async {
    setState(() => _isPressed = true);
    _showSubCategoryDialog(context, widget.catgory);
    if (mounted) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // تعریف رنگ سایه‌ها بر اساس حالت دارک/لایت و حالت فشرده شده
    final shadowColor1 =
        isDarkMode ? Colors.black.withOpacity(0.7) : Colors.grey.shade500;
    final shadowColor2 = isDarkMode ? Colors.grey.shade800 : Colors.white;

    // جابجایی سایه‌ها برای ایجاد حس فرورفتگی
    final pressedShadows = [
      BoxShadow(
        color: shadowColor2, // سایه روشن در پایین-راست
        offset: const Offset(4, 4),
        blurRadius: 8,
      ),
      BoxShadow(
        color: shadowColor2, // سایه تاریک در بالا-چپ
        offset: const Offset(-4, -4),
        blurRadius: 8,
        // مهم: این سایه را داخلی می‌کند
      ),
    ];

    final releasedShadows = [
      BoxShadow(
        color: shadowColor1, // سایه تاریک در پایین-راست
        offset: const Offset(5, 5),
        blurRadius: 7,
      ),
      BoxShadow(
        color: shadowColor2, // سایه روشن در بالا-چپ
        offset: const Offset(-5, -5),
        blurRadius: 7,
      ),
    ];

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: Durations.short1,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isPressed ? pressedShadows : releasedShadows,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 15, child: SizedBox()),
            Expanded(
              flex: 40,
              child: FittedBox(
                child: Icon(
                  IconWrapper.getMaterialIcon(widget.catgory.icon),
                  // size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Expanded(flex: 10, child: SizedBox()),

            Expanded(
              flex: 20,
              child: FittedBox(
                child: Text(
                  widget.catgory.name,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(flex: 15, child: SizedBox()),
          ],
        ),
      ),
    );
  }

  void _showSubCategoryDialog(
    BuildContext context,
    AppliancesCatgory category,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('انتخاب از دسته‌ی ${category.name}'),
            content: SizedBox(
              width: double.maxFinite, // دیالوگ عرض کامل را بگیرد
              // ارتفاع دیالوگ را محدود می‌کنیم تا در صفحات کوچک اسکرول بخورد
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: category.appliance.length,
                      itemBuilder: (context, index) {
                        final subCategory = category.appliance[index];
                        return ListTile(
                          title: Text(subCategory.name),
                          subtitle: Text('${subCategory.powerUsage} وات'),
                          onTap: () {
                            // بستن دیالوگ فعلی
                            Navigator.of(dialogContext).pop();
                            // باز کردن دیالوگ انتخاب ساعت
                            _showHourSelectionDialog(context, subCategory);
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  // دکمه برای افزودن آیتم کاستوم
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('افزودن وسیله جدید'),
                    onPressed: () {
                      // TODO: Implement custom item creation logic
                      // می‌توانید یک دیالوگ دیگر برای گرفتن نام و توان وسیله باز کنید
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('این قابلیت هنوز پیاده‌سازی نشده است.'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('انصراف'),
              ),
            ],
          ),
        );
      },
    );
  }
  // Add this method inside _HomePageState class in home.dart

  void _showHourSelectionDialog(BuildContext context, Appliance appliance) {
    double selectedHours = appliance.houres; // مقدار اولیه از مدل گرفته می‌شود

    showDialog(
      context: context,
      builder: (dialogContext) {
        // StatefulBuilder برای مدیریت state داخلی دیالوگ (مقدار اسلایدر)
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('ساعات کارکرد ${appliance.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'لطفا مشخص کنید این وسیله چند ساعت در شبانه‌روز روشن است.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${selectedHours.toStringAsFixed(1)} ساعت',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Slider(
                    value: selectedHours,
                    min: 0.0,
                    max: 24.0,
                    divisions: 96,
                    label: selectedHours.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        // این setState فقط ویجت داخل StatefulBuilder را آپدیت می‌کند
                        selectedHours = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('لغو'),
                ),
                FilledButton(
                  onPressed: () {
                    // یک کپی از وسیله با ساعت جدید می‌سازیم
                    final finalAppliance = appliance.copyWith(
                      houres: selectedHours,
                    );
                    // وسیله نهایی را به لیست اضافه می‌کنیم
                    BlocProvider.of<HomeCubit>(
                      context,
                    ).addApplianceToSelection(finalAppliance);
                    // دیالوگ را می‌بندیم
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('تایید'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Extension helper for inset shadows (Optional, but good practice)
