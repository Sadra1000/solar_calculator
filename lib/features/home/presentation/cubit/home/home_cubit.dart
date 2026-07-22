import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_calculator/commen/data_state.dart';
import 'package:solar_calculator/commen/services/shared_operator.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/home/model/preset_profiles.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_navigation_event.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_state.dart';
import 'package:solar_calculator/features/home/repository/home_repository.dart';
import 'package:solar_calculator/features/result/model/result_session.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repo;
  final SharedPrefOperator prefs;

  HomeCubit({required this.repo, required this.prefs})
    : super(const HomeState());

  void initialList() {
    emit(state.copyWith(isInitializing: true));
    final saved = prefs.loadSelectedAppliances();
    final cityId = prefs.loadSelectedCityId();
    final rate = prefs.loadElectricityRate();
    final data = repo.getAppliances();
    if (data is DataSuccess<List<AppliancesCategory>>) {
      emit(
        state.copyWith(
          initialList: data.data ?? [],
          selectedAppliance: saved,
          selectedCityId: cityId,
          electricityRateToman: rate,
          isInitializing: false,
        ),
      );
    } else if (data is DataFailed) {
      emit(
        state.copyWith(errorMsg: data.message, isInitializing: false),
      );
    } else {
      emit(state.copyWith(isInitializing: false));
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void clearNavigationEvent() {
    emit(state.copyWith(clearNavigationEvent: true));
  }

  double get totalDailyKwh {
    if (state.selectedAppliance.isEmpty) return 0;
    final map = repo.calculateConsumption(state.selectedAppliance);
    return map['dailyConsumption'] as double;
  }

  void toggleAIProcessing(bool value) {
    emit(state.copyWith(aiprocessing: value));
  }

  void toggleEcoProcessing(bool value) {
    emit(state.copyWith(ecoprocessing: value));
  }

  void toggleEnvirProcessing(bool value) {
    emit(state.copyWith(envirprocessing: value));
  }

  void setSelectedCity(String cityId) {
    emit(state.copyWith(selectedCityId: cityId));
    prefs.saveSelectedCityId(cityId);
  }

  void setElectricityRate(double rate) {
    emit(state.copyWith(electricityRateToman: rate));
    prefs.saveElectricityRate(rate);
  }

  void applyPreset(PresetProfile preset) {
    final appliances = repo.resolvePresetAppliances(preset);
    if (appliances.isEmpty) return;
    _updateSelection(appliances);
  }

  void addOneLike(Appliance appliance) {
    addApplianceToSelection(appliance);
  }

  void removeOneApplianceOfType(String id) {
    final updated = List<Appliance>.from(state.selectedAppliance);
    final idx = updated.indexWhere((e) => e.id == id);
    if (idx != -1) {
      updated.removeAt(idx);
      _updateSelection(updated);
    }
  }

  void removeAllApplianceOfType(String id) {
    final updated = List<Appliance>.from(state.selectedAppliance)
      ..removeWhere((e) => e.id == id);
    _updateSelection(updated);
  }

  void addApplianceToSelection(Appliance appliance) {
    final updatedList = List<Appliance>.from(state.selectedAppliance)
      ..add(appliance);
    _updateSelection(updatedList);
  }

  void addCustomAppliance({
    required int categoryIcon,
    required String name,
    required int watts,
    required double hours,
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || watts <= 0) return;
    addApplianceToSelection(
      Appliance.custom(
        icon: categoryIcon,
        name: trimmed,
        powerUsage: watts,
        houres: hours,
      ),
    );
  }

  void updateGroupHours(String id, double hours) {
    final updated =
        state.selectedAppliance
            .map((a) => a.id == id ? a.copyWith(houres: hours) : a)
            .toList();
    _updateSelection(updated);
  }

  void removeApplianceFromSelectionByIndex(int index) {
    final updatedList = List<Appliance>.from(state.selectedAppliance);
    if (index >= 0 && index < updatedList.length) {
      updatedList.removeAt(index);
      _updateSelection(updatedList);
    }
  }

  /// Builds local result and signals navigation; AI runs on the result page.
  void process({required String languageCode}) {
    if (state.selectedAppliance.isEmpty) return;

    emit(state.copyWith(isLoading: true, clearNavigationEvent: true, clearError: true));

    final result = repo.buildResultModel(
      appliances: state.selectedAppliance,
      cityId: state.selectedCityId,
      electricityRateToman: state.electricityRateToman,
      languageCode: languageCode,
    );

    final session = ResultSession(
      result: result,
      appliances: List<Appliance>.from(state.selectedAppliance),
      cityId: state.selectedCityId,
      languageCode: languageCode,
      requestAi: state.aiprocessing,
      electricityRateToman: state.electricityRateToman,
    );

    emit(
      state.copyWith(
        isLoading: false,
        navigationEvent: HomeNavigationEvent(session: session),
      ),
    );
  }

  void setApplianceSearchQuery(String query) {
    emit(state.copyWith(applianceSearchQuery: query));
  }

  void _updateSelection(List<Appliance> appliances) {
    emit(state.copyWith(selectedAppliance: appliances));
    prefs.saveSelectedAppliances(appliances);
  }
}
