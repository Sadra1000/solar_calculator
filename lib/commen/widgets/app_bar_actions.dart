import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';
import 'package:solar_calculator/theme/locale_cubit.dart';
import 'package:solar_calculator/theme/theme_cubit.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key, this.showHistory = true});

  final bool showHistory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHistory)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: l10n.historyTitle,
              onPressed: () => context.push('/history'),
            ),
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              final isFa = locale.languageCode == 'fa';
              return IconButton(
                icon: Icon(isFa ? Icons.translate : Icons.language),
                tooltip: l10n.languageToggle,
                onPressed: () => context.read<LocaleCubit>().toggleLocale(),
              );
            },
          ),
          BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDark) {
              return IconButton(
              
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: l10n.themeToggle,
                onPressed: () => context.read<ThemeCubit>().changeThemeMode(),
              );
            },
          ),
        ],
      ),
    );
  }
}
