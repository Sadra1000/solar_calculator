import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/features/home/presentation/screen/home.dart';
import 'package:solar_calculator/features/result/presentation/screen/result.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';
import 'package:solar_calculator/locator.dart';
import 'package:solar_calculator/theme/theme.dart';
import 'package:solar_calculator/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocato();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<ThemeCubit>()),
        BlocProvider(create: (_) => locator<HomeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (_, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            locale: const Locale('fa'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: '/',
            routes: {
              '/': (context) => const HomePage(),
              '/result': (context) => const ResultPage(),
            },
            theme: MyTheme.lightTheme(),
            darkTheme: MyTheme.darkTheme(),
            themeMode: state ? ThemeMode.light : ThemeMode.dark,
          );
        },
      ),
    );
  }
}
