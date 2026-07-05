import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_calculator/commen/helpers/persian.dart';
import 'package:solar_calculator/commen/helpers/icon_helper.dart';
import 'package:solar_calculator/commen/layout/responsive.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final shadowColor1 =
        isDarkMode ? Colors.black.withOpacity(0.7) : Colors.grey.shade500;
    final shadowColor2 = isDarkMode ? Colors.grey.shade800 : Colors.white;

    final pressedShadows = [
      BoxShadow(
        color: shadowColor2,
        offset: const Offset(4, 4),
        blurRadius: 8,
      ),
      BoxShadow(
        color: shadowColor2,
        offset: const Offset(-4, -4),
        blurRadius: 8,
      ),
    ];

    final releasedShadows = [
      BoxShadow(
        color: shadowColor1,
        offset: const Offset(5, 5),
        blurRadius: 7,
      ),
      BoxShadow(
        color: shadowColor2,
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
            Icon(
              IconWrapper.getMaterialIcon(widget.catgory.icon),
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                widget.catgory.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubCategoryDialog(
    BuildContext context,
    AppliancesCatgory category,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final textDirection =
        Localizations.localeOf(context).languageCode == 'fa'
            ? TextDirection.rtl
            : TextDirection.ltr;
    final maxHeight = MediaQuery.sizeOf(context).height;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: textDirection,
          child: AlertDialog(
            title: Text(l10n.selectFromCategory(category.name)),
            content: SizedBox(
              width: double.maxFinite,
              height: adaptiveDialogHeight(maxHeight),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: category.appliance.length,
                      itemBuilder: (context, index) {
                        final subCategory = category.appliance[index];
                        return ListTile(
                          title: Text(subCategory.name),
                          subtitle: Text(
                            l10n.watts(subCategory.powerUsage),
                          ),
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            _showHourSelectionDialog(context, subCategory);
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addNewAppliance),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.featureNotImplemented)),
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
                child: Text(l10n.cancel),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHourSelectionDialog(BuildContext context, Appliance appliance) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    double selectedHours = appliance.houres;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.operatingHours(appliance.name)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.hoursPrompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.hoursValue(
                      selectedHours
                          .toStringAsFixed(1)
                          .localizedDigits(locale),
                    ),
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
                        selectedHours = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.dismiss),
                ),
                FilledButton(
                  onPressed: () {
                    final finalAppliance = appliance.copyWith(
                      houres: selectedHours,
                    );
                    BlocProvider.of<HomeCubit>(
                      context,
                    ).addApplianceToSelection(finalAppliance);
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.confirm),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
