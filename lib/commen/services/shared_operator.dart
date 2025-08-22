import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefOperator {
  // static const String _key = 'conversations';
  final SharedPreferences sharedPreferences;
  SharedPrefOperator(this.sharedPreferences);
  Future<void> setUserVisitedOnboarding(bool hasVisited) async {
    await sharedPreferences.setBool('user_visited_onboarding', hasVisited);
  }

  bool hasUserVisitedOnboarding() {
    return sharedPreferences.getBool('user_visited_onboarding') ?? false;
  }
}
