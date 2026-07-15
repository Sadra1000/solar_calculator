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
  final VoidCallback onEditHours;

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
    required this.onEditHours,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final onCard = theme.colorScheme.onTertiaryContainer;
    final padding = adaptiveGroupCardPadding(maxWidth);
    final isCompact = maxWidth < 400;

    return GestureDetector(
      onLongPress: onEditHours,
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.tertiaryContainer,
        ),
        child:
            isCompact
                ? _CompactLayout(
                  icon: icon,
                  name: name,
                  totalWh: totalWh,
                  count: count,
                  locale: locale,
                  onCard: onCard,
                  onAdd: onAdd,
                  onRemoveOne: onRemoveOne,
                  onRemoveAll: onRemoveAll,
                  onEditHours: onEditHours,
                )
                : _StandardLayout(
                  icon: icon,
                  name: name,
                  totalWh: totalWh,
                  count: count,
                  locale: locale,
                  onCard: onCard,
                  onAdd: onAdd,
                  onRemoveOne: onRemoveOne,
                  onRemoveAll: onRemoveAll,
                  onEditHours: onEditHours,
                ),
      ),
    );
  }
}

class _StandardLayout extends StatelessWidget {
  final IconData icon;
  final String name;
  final int totalWh;
  final int count;
  final Locale locale;
  final Color onCard;
  final VoidCallback onAdd;
  final VoidCallback onRemoveOne;
  final VoidCallback onRemoveAll;
  final VoidCallback onEditHours;

  const _StandardLayout({
    required this.icon,
    required this.name,
    required this.totalWh,
    required this.count,
    required this.locale,
    required this.onCard,
    required this.onAdd,
    required this.onRemoveOne,
    required this.onRemoveAll,
    required this.onEditHours,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: onCard, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: onCard,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.totalPower(totalWh.toString().toWhPersian(locale)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onCard.withValues(alpha: 0.85),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        _EditButton(onEditHours: onEditHours, onCard: onCard),
        _QuantityController(
          count: count,
          locale: locale,
          onCard: onCard,
          onAdd: onAdd,
          onRemoveOne: onRemoveOne,
          onRemoveAll: onRemoveAll,
        ),
      ],
    );
  }
}

class _CompactLayout extends StatelessWidget {
  final IconData icon;
  final String name;
  final int totalWh;
  final int count;
  final Locale locale;
  final Color onCard;
  final VoidCallback onAdd;
  final VoidCallback onRemoveOne;
  final VoidCallback onRemoveAll;
  final VoidCallback onEditHours;

  const _CompactLayout({
    required this.icon,
    required this.name,
    required this.totalWh,
    required this.count,
    required this.locale,
    required this.onCard,
    required this.onAdd,
    required this.onRemoveOne,
    required this.onRemoveAll,
    required this.onEditHours,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: onCard, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: onCard,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.totalPower(totalWh.toString().toWhPersian(locale)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onCard.withValues(alpha: 0.85),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _EditButton(onEditHours: onEditHours, onCard: onCard),
            _QuantityController(
              count: count,
              locale: locale,
              onCard: onCard,
              onAdd: onAdd,
              onRemoveOne: onRemoveOne,
              onRemoveAll: onRemoveAll,
            ),
          ],
        ),
      ],
    );
  }
}

class _EditButton extends StatelessWidget {
  final VoidCallback onEditHours;
  final Color onCard;

  const _EditButton({required this.onEditHours, required this.onCard});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return IconButton(
      onPressed: onEditHours,
      icon: Icon(Icons.edit_outlined, color: onCard),
      tooltip: l10n.editHours,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}

class _QuantityController extends StatelessWidget {
  final int count;
  final Locale locale;
  final Color onCard;
  final VoidCallback onAdd;
  final VoidCallback onRemoveOne;
  final VoidCallback onRemoveAll;

  const _QuantityController({
    required this.count,
    required this.locale,
    required this.onCard,
    required this.onAdd,
    required this.onRemoveOne,
    required this.onRemoveAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onAdd,
          icon: Icon(Icons.add, color: onCard),
          tooltip: l10n.addOne,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
        SizedBox(
          width: 28,
          child: Text(
            count.toString().localizedDigits(locale),
            style: theme.textTheme.titleSmall?.copyWith(
              color: onCard,
              fontWeight: FontWeight.w700,
            ),
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
        icon: Icon(Icons.remove_circle_outline, color: onCard),
        tooltip: l10n.removeOne,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      );
    }

    return IconButton(
      onPressed: onRemoveAll,
      icon: Icon(Icons.delete_outline, color: onCard),
      tooltip: l10n.removeAll,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
