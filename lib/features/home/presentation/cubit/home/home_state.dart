import 'package:equatable/equatable.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_navigation_event.dart';

class HomeState extends Equatable {
  const HomeState({
    this.aiprocessing = false,
    this.ecoprocessing = true,
    this.envirprocessing = true,
    this.isLoading = false,
    this.isInitializing = false,
    this.errorMsg,
    this.selectedAppliance = const [],
    this.initialList = const [],
    this.selectedCityId = 'tehran',
    this.electricityRateToman = 2500,
    this.navigationEvent,
    this.applianceSearchQuery = '',
  });

  final bool aiprocessing;
  final bool ecoprocessing;
  final bool envirprocessing;
  final bool isLoading;
  final bool isInitializing;
  final String? errorMsg;
  final List<Appliance> selectedAppliance;
  final List<AppliancesCategory> initialList;
  final String selectedCityId;
  final double electricityRateToman;
  final HomeNavigationEvent? navigationEvent;
  final String applianceSearchQuery;

  HomeState copyWith({
    bool? aiprocessing,
    bool? ecoprocessing,
    bool? envirprocessing,
    bool? isLoading,
    bool? isInitializing,
    String? errorMsg,
    bool clearError = false,
    List<Appliance>? selectedAppliance,
    List<AppliancesCategory>? initialList,
    String? selectedCityId,
    double? electricityRateToman,
    HomeNavigationEvent? navigationEvent,
    bool clearNavigationEvent = false,
    String? applianceSearchQuery,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isInitializing: isInitializing ?? this.isInitializing,
      errorMsg: clearError ? null : (errorMsg ?? this.errorMsg),
      aiprocessing: aiprocessing ?? this.aiprocessing,
      ecoprocessing: ecoprocessing ?? this.ecoprocessing,
      envirprocessing: envirprocessing ?? this.envirprocessing,
      selectedAppliance: selectedAppliance ?? this.selectedAppliance,
      initialList: initialList ?? this.initialList,
      selectedCityId: selectedCityId ?? this.selectedCityId,
      electricityRateToman: electricityRateToman ?? this.electricityRateToman,
      navigationEvent:
          clearNavigationEvent
              ? null
              : (navigationEvent ?? this.navigationEvent),
      applianceSearchQuery: applianceSearchQuery ?? this.applianceSearchQuery,
    );
  }

  @override
  List<Object?> get props => [
    aiprocessing,
    ecoprocessing,
    envirprocessing,
    isLoading,
    isInitializing,
    errorMsg,
    selectedAppliance,
    initialList,
    selectedCityId,
    electricityRateToman,
    navigationEvent,
    applianceSearchQuery,
  ];
}
