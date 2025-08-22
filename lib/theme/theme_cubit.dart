import 'package:bloc/bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false for light mode, true for dark mode

  void changeThemeMode() async {
    emit(!state);
  }
}
