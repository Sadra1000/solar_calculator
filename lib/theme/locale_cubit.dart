import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:solar_calculator/commen/services/shared_operator.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._prefs) : super(Locale(_prefs.loadLocaleCode()));

  final SharedPrefOperator _prefs;

  void toggleLocale() {
    final next =
        state.languageCode == 'fa'
            ? const Locale('en')
            : const Locale('fa');
    emit(next);
    _prefs.saveLocaleCode(next.languageCode);
  }
}
