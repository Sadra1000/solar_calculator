import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/features/home/presentation/screen/home.dart';
import 'package:solar_calculator/features/result/presentation/screen/result.dart';
import 'package:solar_calculator/locator.dart';
import 'package:solar_calculator/theme/theme.dart';
import 'package:solar_calculator/theme/theme_cubit.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocato();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext ontext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ontext) => locator<ThemeCubit>()),
        BlocProvider(create: (ontext) => locator<HomeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (_, state) {
          return Sizer(
            builder: (context, _, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: "/",
                routes: {
                  '/': (context) => HomePage(),
                  '/result': (context) => ResultPage(),
                },
                theme: MyTheme.lightTheme(),
                darkTheme: MyTheme.darkTheme(),
                themeMode: state ? ThemeMode.light : ThemeMode.dark,
              );
            },
          );
        },
      ),
    );
  }
}
