import 'package:bloc/bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(true); // false for light mode, true for dark mode

  void changeThemeMode() async {
    emit(!state);
  }
}
