import 'package:equatable/equatable.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/result/repository/model.dart';

/// Navigation payload from home → result (go_router extra).
class ResultSession extends Equatable {
  const ResultSession({
    required this.result,
    required this.appliances,
    required this.cityId,
    required this.languageCode,
    required this.requestAi,
    required this.electricityRateToman,
  });

  final ResulteModel result;
  final List<Appliance> appliances;
  final String cityId;
  final String languageCode;
  final bool requestAi;
  final double electricityRateToman;

  @override
  List<Object?> get props => [
    result,
    appliances,
    cityId,
    languageCode,
    requestAi,
    electricityRateToman,
  ];
}
