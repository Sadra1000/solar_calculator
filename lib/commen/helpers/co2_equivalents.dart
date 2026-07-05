/// Approximate CO2 offset equivalents for yearly emissions display.
abstract final class Co2Equivalents {
  static const double kgCo2PerTreeYear = 21.0;
  static const double kgCo2PerCarKm = 0.12;

  static double treeCount(double yearlyKgCo2) =>
      (yearlyKgCo2 / kgCo2PerTreeYear).clamp(0, double.infinity);

  static double carKmEquivalent(double yearlyKgCo2) =>
      (yearlyKgCo2 / kgCo2PerCarKm).clamp(0, double.infinity);
}
