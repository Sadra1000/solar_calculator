import 'package:solar_calculator/features/home/model/appliances.dart';

class HomeState {
  const HomeState({
    this.aiprocessing = false,
    this.ecoprocessing = true,
    this.envirprocessing = true,
    this.isLoading = false,
    this.errorMsg,
    this.selectedAppliance = const [],
    this.initialList = const [],
  });
  final bool aiprocessing;
  final bool ecoprocessing;
  final bool envirprocessing;
  final bool isLoading;
  final String? errorMsg;
  final List<Appliance> selectedAppliance;
  final List<AppliancesCatgory> initialList;

  copyWith({
    bool? aiprocessing,
    bool? ecoprocessing,
    bool? envirprocessing,
    bool? isLoading,
    String? errorMsg,
    List<Appliance>? selectedAppliance,
    List<AppliancesCatgory>? initialList,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      aiprocessing: aiprocessing ?? this.aiprocessing,
      ecoprocessing: ecoprocessing ?? this.ecoprocessing,
      envirprocessing: envirprocessing ?? this.envirprocessing,
      selectedAppliance: selectedAppliance ?? this.selectedAppliance,
      initialList: initialList ?? this.initialList,
    );
  }
}
