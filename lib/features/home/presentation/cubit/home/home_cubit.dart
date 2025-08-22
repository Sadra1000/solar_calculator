// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_calculator/commen/data_state.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_state.dart';
import 'package:solar_calculator/features/home/repository/home_repository.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/result/repository/model.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repo;

  HomeCubit({required this.repo}) : super(const HomeState());
  void initialList() {
    emit(state.copyWith(isLoading: true));
    final data = repo.getAppliances();
    if (data is DataSuccess<List<AppliancesCatgory>>) {
      emit(state.copyWith(initialList: data.data));
    } else if (data is DataFailed) {
      emit(state.copyWith(errorMsg: data.message));
    }
    emit(state.copyWith(isLoading: false));
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

  void addOneLike(Appliance appliance) {
    addApplianceToSelection(appliance);
  }

  void removeOneApplianceOfType(String name) {
    final updated = List<Appliance>.from(state.selectedAppliance);
    final idx = updated.indexWhere((e) => e.name == name);
    if (idx != -1) {
      updated.removeAt(idx);
      emit(state.copyWith(selectedAppliance: updated));
    }
  }

  void removeAllApplianceOfType(String name) {
    final updated = List<Appliance>.from(state.selectedAppliance)
      ..removeWhere((e) => e.name == name);
    emit(state.copyWith(selectedAppliance: updated));
  }

  void addApplianceToSelection(Appliance appliance) {
    final updatedList = List<Appliance>.from(state.selectedAppliance)
      ..add(appliance);
    emit(state.copyWith(selectedAppliance: updatedList));
  }

  void removeApplianceFromSelectionByIndex(int index) {
    final updatedList = List<Appliance>.from(state.selectedAppliance);
    if (index >= 0 && index < updatedList.length) {
      updatedList.removeAt(index);
      emit(state.copyWith(selectedAppliance: updatedList));
    }
  }

  void process(BuildContext c) async {
    if (state.selectedAppliance.isEmpty) {
      return;
    }
    emit(state.copyWith(isLoading: true));

    Map<String, dynamic> map = repo.calculateConsumption(
      state.selectedAppliance,
    );
    DataState dataState = await repo.callDeepSeek(state.selectedAppliance);
    if (dataState is DataSuccess) {
      Navigator.of(c).pop();
      Navigator.pushNamed(
        c,
        "/result",
        arguments: ResulteModel(
          analysis: (dataState).data,
          dailyConsumption: map["dailyConsumption"],
          monthlyConsumption: map["monthlyConsumption"],
          yearlyConsumption: map["yearlyConsumption"],
          yearlyCo2Production: map["yearlyCo2Production"],
        ),
      );
      emit(state.copyWith(isLoading: false));
    } else {
      Navigator.of(c).pop();
      emit(state.copyWith(isLoading: false, errorMsg: dataState.message));
    }
  }
}
