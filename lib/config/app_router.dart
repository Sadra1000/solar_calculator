import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_calculator/commen/services/shared_operator.dart';
import 'package:solar_calculator/features/history/presentation/screen/history.dart';
import 'package:solar_calculator/features/home/presentation/screen/home.dart';
import 'package:solar_calculator/features/home/repository/home_repository.dart';
import 'package:solar_calculator/features/onboarding/presentation/screen/onboarding.dart';
import 'package:solar_calculator/features/result/model/result_session.dart';
import 'package:solar_calculator/features/result/presentation/cubit/result_cubit.dart';
import 'package:solar_calculator/features/result/presentation/screen/result.dart';
import 'package:solar_calculator/locator.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final prefs = locator<SharedPrefOperator>();
      final onOnboarding = state.matchedLocation == '/onboarding';
      if (!prefs.hasUserVisitedOnboarding() && !onOnboarding) {
        return '/onboarding';
      }
      if (prefs.hasUserVisitedOnboarding() && onOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) {
          final session = state.extra! as ResultSession;
          return BlocProvider(
            create:
                (_) => ResultCubit(
                  repo: locator<HomeRepository>(),
                  prefs: locator<SharedPrefOperator>(),
                )..start(session),
            child: const ResultPage(),
          );
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryPage(),
      ),
    ],
  );
}
