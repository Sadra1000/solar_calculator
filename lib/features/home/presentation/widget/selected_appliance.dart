import 'package:flutter/material.dart';
import 'package:solar_calculator/commen/helpers/persian.dart';
import 'package:solar_calculator/commen/layout/responsive.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';

class GroupCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final int count;
  final int totalWh;
  final double maxWidth;
  final VoidCallback onAdd;
  final VoidCallback onRemoveOne;
  final VoidCallback onRemoveAll;

  const GroupCard({
    super.key,
    required this.icon,
    required this.name,
    required this.count,
    required this.totalWh,
    required this.maxWidth,
    required this.onAdd,
    required this.onRemoveOne,
    required this.onRemoveAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final cardHeight = adaptiveGroupCardHeight(maxWidth);

    return Container(
      height: cardHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.tertiaryContainer,
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            flex: 25,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    l10n.totalPower(
                      totalWh.toString().toWhPersian(locale),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          _QuantityController(
            count: count,
            locale: locale,
            onAdd: onAdd,
            onRemoveOne: onRemoveOne,
            onRemoveAll: onRemoveAll,
          ),
        ],
      ),
    );
  }
}

class _QuantityController extends StatelessWidget {
  final int count;
  final Locale locale;
  final VoidCallback onAdd;
  final VoidCallback onRemoveOne;
  final VoidCallback onRemoveAll;

  const _QuantityController({
    required this.count,
    required this.locale,
    required this.onAdd,
    required this.onRemoveOne,
    required this.onRemoveAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          tooltip: l10n.addOne,
        ),
        SizedBox(
          width: 32,
          child: Text(
            count.toString().localizedDigits(locale),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        _buildRemoveButton(l10n),
      ],
    );
  }

  Widget _buildRemoveButton(AppLocalizations l10n) {
    if (count >= 2) {
      return IconButton(
        onPressed: onRemoveOne,
        icon: const Icon(Icons.remove_circle_outline),
        tooltip: l10n.removeOne,
      );
    }

    return IconButton(
      onPressed: onRemoveAll,
      icon: const Icon(Icons.delete_outline),
      tooltip: l10n.removeAll,
    );
  }
}
