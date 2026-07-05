import 'package:bloc/bloc.dart';
import 'package:solar_calculator/commen/services/shared_operator.dart';

/// `false` = light theme, `true` = dark theme.
class ThemeCubit extends Cubit<bool> {
  ThemeCubit(this._prefs) : super(_prefs.loadDarkMode());

  final SharedPrefOperator _prefs;

  void changeThemeMode() {
    final isDark = !state;
    emit(isDark);
    _prefs.saveDarkMode(isDark);
  }
}
