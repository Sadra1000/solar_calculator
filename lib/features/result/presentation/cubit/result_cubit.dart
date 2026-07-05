import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solar_calculator/commen/data_state.dart';
import 'package:solar_calculator/commen/helpers/result_share.dart';
import 'package:solar_calculator/commen/services/shared_operator.dart';
import 'package:solar_calculator/features/history/model/calculation_history_entry.dart';
import 'package:solar_calculator/features/home/repository/home_repository.dart';
import 'package:solar_calculator/features/result/model/result_session.dart';
import 'package:solar_calculator/features/result/presentation/cubit/result_state.dart';
import 'package:solar_calculator/features/result/repository/model.dart';
import 'package:solar_calculator/features/solar/iran_cities.dart';
import 'package:solar_calculator/features/solar/solar_calculator.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';

class ResultCubit extends Cubit<ResultState> {
  ResultCubit({
    required HomeRepository repo,
    required SharedPrefOperator prefs,
  }) : _repo = repo,
       _prefs = prefs,
       super(
         ResultState(
           session: ResultSession(
             result: _placeholderResult,
             appliances: const [],
             cityId: 'tehran',
             languageCode: 'fa',
             requestAi: false,
             electricityRateToman: 2500,
           ),
         ),
       );

  static final _placeholderResult = ResulteModel(
    analysis: '',
    dailyConsumption: 0,
    monthlyConsumption: 0,
    yearlyConsumption: 0,
    yearlyCo2Production: 0,
    applianceShares: const [],
    solarSizing: SolarCalculator.calculate(
      dailyKwh: 0,
      city: cityById('tehran'),
    ),
    monthlyCostToman: 0,
    yearlyCostToman: 0,
    electricityRateToman: 2500,
  );

  final HomeRepository _repo;
  final SharedPrefOperator _prefs;
  StreamSubscription<String>? _streamSub;

  void start(ResultSession session) {
    emit(
      ResultState(
        session: session,
        result: session.result,
        isStreaming: session.requestAi,
        isFallback: false,
      ),
    );

    if (session.requestAi) {
      _loadAnalysis(streamFirst: true);
    } else {
      _saveHistory();
    }
  }

  Future<void> refresh() async {
    if (!state.session.requestAi) return;

    emit(
      state.copyWith(
        isRefreshing: true,
        isStreaming: true,
        isFallback: false,
        result: state.session.result.copyWith(analysis: ''),
      ),
    );
    await _loadAnalysis(streamFirst: true);
    emit(state.copyWith(isRefreshing: false));
  }

  Future<void> share(AppLocalizations l10n) async {
    try {
      await Share.share(buildResultShareText(l10n, state.data));
      emit(state.copyWith(shareMessage: 'shared'));
    } catch (_) {
      emit(state.copyWith(shareMessage: 'share_failed'));
    }
  }

  void clearShareMessage() {
    if (state.shareMessage != null) {
      emit(state.copyWith(clearShareMessage: true));
    }
  }

  Future<void> _loadAnalysis({required bool streamFirst}) async {
    await _streamSub?.cancel();
    _streamSub = null;

    final session = state.session;
    final city = cityById(session.cityId);
    final cityName = city.localizedName(session.languageCode);
    final daily = session.result.dailyConsumption;
    final monthly = session.result.monthlyConsumption;
    final yearly = session.result.yearlyConsumption;

    if (streamFirst) {
      final usedStream = await _tryStream(
        cityName: cityName,
        dailyKwh: daily,
        monthlyKwh: monthly,
        yearlyKwh: yearly,
      );
      if (usedStream) return;
    }

    await _tryNonStream(
      cityName: cityName,
      dailyKwh: daily,
      monthlyKwh: monthly,
      yearlyKwh: yearly,
    );
  }

  Future<bool> _tryStream({
    required String cityName,
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
  }) async {
    try {
      final buffer = StringBuffer();
      final completer = Completer<bool>();
      final session = state.session;

      _streamSub = _repo
          .streamDeepSeek(
            appliances: session.appliances,
            dailyKwh: dailyKwh,
            monthlyKwh: monthlyKwh,
            yearlyKwh: yearlyKwh,
            cityDisplayName: cityName,
            electricityRateToman: session.electricityRateToman,
          )
          .listen(
            (chunk) {
              buffer.write(chunk);
              emit(
                state.copyWith(
                  result: state.session.result.copyWith(
                    analysis: buffer.toString(),
                  ),
                  isStreaming: true,
                ),
              );
            },
            onError: (_) {
              if (!completer.isCompleted) completer.complete(false);
            },
            onDone: () async {
              final text = buffer.toString().trim();
              if (text.isNotEmpty) {
                emit(
                  state.copyWith(
                    result: state.session.result.copyWith(analysis: text),
                    isStreaming: false,
                    isFallback: false,
                  ),
                );
                await _saveHistory();
                if (!completer.isCompleted) completer.complete(true);
              } else if (!completer.isCompleted) {
                completer.complete(false);
              }
            },
            cancelOnError: true,
          );

      return await completer.future;
    } catch (_) {
      return false;
    }
  }

  Future<void> _tryNonStream({
    required String cityName,
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
  }) async {
    final session = state.session;
    final apiResult = await _repo.callDeepSeek(
      appliances: session.appliances,
      dailyKwh: dailyKwh,
      monthlyKwh: monthlyKwh,
      yearlyKwh: yearlyKwh,
      cityDisplayName: cityName,
      electricityRateToman: session.electricityRateToman,
    );

    if (apiResult is DataSuccess<String> && apiResult.data != null) {
      emit(
        state.copyWith(
          result: session.result.copyWith(analysis: apiResult.data!),
          isStreaming: false,
          isFallback: false,
        ),
      );
      await _saveHistory();
      return;
    }

    _applyFallback(cityName: cityName);
  }

  void _applyFallback({required String cityName}) {
    final session = state.session;
    final text = _repo.buildFallbackAnalysis(
      dailyKwh: session.result.dailyConsumption,
      monthlyKwh: session.result.monthlyConsumption,
      yearlyKwh: session.result.yearlyConsumption,
      cityDisplayName: cityName,
      electricityRateToman: session.electricityRateToman,
    );
    emit(
      state.copyWith(
        result: session.result.copyWith(analysis: text),
        isStreaming: false,
        isFallback: true,
      ),
    );
    _saveHistory();
  }

  Future<void> _saveHistory() async {
    final session = state.session;
    final summary =
        session.appliances.map((a) => a.name).toSet().join('، ');
    await _prefs.addCalculationHistory(
      CalculationHistoryEntry.fromResult(
        state.data,
        applianceCount: session.appliances.length,
        applianceSummary: summary,
      ),
    );
  }

  @override
  Future<void> close() {
    _streamSub?.cancel();
    return super.close();
  }
}
