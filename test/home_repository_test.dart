import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_calculator/features/home/data/remote/home_api.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/home/repository/home_repository.dart';

void main() {
  late HomeRepository repository;

  setUp(() {
    repository = HomeRepository(api: HomeApi(dio: Dio()));
  });

  group('calculateConsumption', () {
    test('returns zero for empty appliance list', () {
      final result = repository.calculateConsumption([]);

      expect(result['dailyConsumption'], 0.0);
      expect(result['monthlyConsumption'], 0.0);
      expect(result['yearlyConsumption'], 0.0);
      expect(result['yearlyCo2Production'], 0.0);
    });

    test('sums daily kWh from watts and hours', () {
      const appliances = [
        Appliance(
          id: 'lamp',
          icon: 1,
          nameFa: 'لامپ',
          nameEn: 'Lamp',
          powerUsage: 1000,
          houres: 2,
        ),
        Appliance(
          id: 'fan',
          icon: 1,
          nameFa: 'پنکه',
          nameEn: 'Fan',
          powerUsage: 500,
          houres: 4,
        ),
      ];

      final result = repository.calculateConsumption(appliances);

      expect(result['dailyConsumption'], 4.0);
      expect(result['yearlyConsumption'], 4.0 * 365);
      expect(result['monthlyConsumption'], closeTo(4.0 * 365 / 12, 0.001));
      expect(result['yearlyCo2Production'], closeTo(4.0 * 365 * 0.417, 0.001));
    });

    test('counts duplicate appliances separately', () {
      const appliance = Appliance(
        id: 'tv',
        icon: 1,
        nameFa: 'تلویزیون',
        nameEn: 'TV',
        powerUsage: 200,
        houres: 5,
      );

      final result = repository.calculateConsumption([appliance, appliance]);

      expect(result['dailyConsumption'], 2.0);
    });
  });

  group('computeApplianceShares', () {
    test('aggregates consumption by appliance id', () {
      const tv = Appliance(
        id: 'tv',
        icon: 1,
        nameFa: 'تلویزیون',
        nameEn: 'TV',
        powerUsage: 100,
        houres: 10,
      );
      const lamp = Appliance(
        id: 'lamp',
        icon: 2,
        nameFa: 'لامپ',
        nameEn: 'Lamp',
        powerUsage: 50,
        houres: 4,
      );

      final shares = repository.computeApplianceShares(
        [tv, tv, lamp],
        languageCode: 'en',
      );

      expect(shares.length, 2);
      expect(shares.firstWhere((s) => s.name == 'TV').dailyKwh, 2.0);
      expect(shares.firstWhere((s) => s.name == 'Lamp').dailyKwh, 0.2);
    });
  });
}
