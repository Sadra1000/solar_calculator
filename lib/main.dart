import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_calculator/config/app_router.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';
import 'package:solar_calculator/locator.dart';
import 'package:solar_calculator/theme/locale_cubit.dart';
import 'package:solar_calculator/theme/theme.dart';
import 'package:solar_calculator/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    GoRouter.optionURLReflectsImperativeAPIs = true;
  }

  await setupLocato();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<ThemeCubit>()),
        BlocProvider(create: (_) => locator<LocaleCubit>()),
        BlocProvider(create: (_) => locator<HomeCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, bool>(
            builder: (_, isDark) {
              final usePersianFont = locale.languageCode == 'fa';
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                onGenerateTitle:
                    (context) => AppLocalizations.of(context)!.appTitle,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                theme: MyTheme.lightTheme(usePersianFont: usePersianFont),
                darkTheme: MyTheme.darkTheme(usePersianFont: usePersianFont),
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                routerConfig: _router,
              );
            },
          );
        },
      ),
    );
  }
}
