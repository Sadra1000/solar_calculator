class ResulteModel {
  final double dailyConsumption; // مصرف روزانه به kWh
  final double monthlyConsumption; // مصرف ماهانه به kWh
  final double yearlyConsumption; // مصرف سالانه به kWh
  final double yearlyCo2Production; // تولید CO2 سالانه به کیلوگرم
  final String analysis;
  const ResulteModel({
    required this.analysis,
    required this.dailyConsumption,
    required this.monthlyConsumption,
    required this.yearlyConsumption,
    required this.yearlyCo2Production,
  });

  @override
  String toString() {
    return '''
ResulteModel(
  Daily Consumption:   ${dailyConsumption.toStringAsFixed(2)} kWh
  Monthly Consumption: ${monthlyConsumption.toStringAsFixed(2)} kWh
  Yearly Consumption:  ${yearlyConsumption.toStringAsFixed(2)} kWh
  Yearly CO2 Production: ${yearlyCo2Production.toStringAsFixed(2)} kg
)''';
  }
}
