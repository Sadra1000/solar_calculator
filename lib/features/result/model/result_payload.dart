import 'package:equatable/equatable.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';

/// Data passed from home to result via go_router extra.
class ResultPayload extends Equatable {
  const ResultPayload({
    required this.selectedAppliances,
    required this.dailyConsumption,
    required this.monthlyConsumption,
    required this.yearlyConsumption,
    required this.yearlyCo2Production,
    this.city = 'تهران',
    this.budget,
  });

  final List<Appliance> selectedAppliances;
  final double dailyConsumption;
  final double monthlyConsumption;
  final double yearlyConsumption;
  final double yearlyCo2Production;
  final String city;
  final String? budget;

  @override
  List<Object?> get props => [
    selectedAppliances,
    dailyConsumption,
    monthlyConsumption,
    yearlyConsumption,
    yearlyCo2Production,
    city,
    budget,
  ];
}
