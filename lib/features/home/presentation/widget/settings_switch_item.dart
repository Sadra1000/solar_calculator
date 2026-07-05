import 'package:flutter/material.dart';

class SettingsSwitchItem extends StatelessWidget {
  const SettingsSwitchItem({
    super.key,
    required this.scalefactor,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.padding,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final double scalefactor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => onChanged(!value) : null,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                width: 35,
                height: 35,
                alignment: Alignment.center,
                child: Icon(icon, size: 32, color: colorScheme.secondary),
              ),
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              enabled: enabled,
              trailing: Switch.adaptive(
                value: value,
                onChanged: enabled ? onChanged : null,
                activeThumbColor: colorScheme.onPrimary,
                activeTrackColor: colorScheme.primary,
                inactiveThumbColor: colorScheme.onSurface,
                inactiveTrackColor: colorScheme.surfaceContainerHighest,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
