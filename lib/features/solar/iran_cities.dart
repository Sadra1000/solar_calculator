class IranCity {
  const IranCity({
    required this.id,
    required this.nameFa,
    required this.nameEn,
    required this.irradianceKwhPerM2Day,
  });

  final String id;
  final String nameFa;
  final String nameEn;
  final double irradianceKwhPerM2Day;

  String localizedName(String languageCode) =>
      languageCode == 'fa' ? nameFa : nameEn;
}

/// Peak sun hours / daily irradiance factors for major Iranian cities (kWh/m²/day).
const List<IranCity> iranCities = [
  IranCity(
    id: 'tehran',
    nameFa: 'تهران',
    nameEn: 'Tehran',
    irradianceKwhPerM2Day: 5.0,
  ),
  IranCity(
    id: 'isfahan',
    nameFa: 'اصفهان',
    nameEn: 'Isfahan',
    irradianceKwhPerM2Day: 5.5,
  ),
  IranCity(
    id: 'shiraz',
    nameFa: 'شیراز',
    nameEn: 'Shiraz',
    irradianceKwhPerM2Day: 5.3,
  ),
  IranCity(
    id: 'mashhad',
    nameFa: 'مشهد',
    nameEn: 'Mashhad',
    irradianceKwhPerM2Day: 4.8,
  ),
  IranCity(
    id: 'tabriz',
    nameFa: 'تبریز',
    nameEn: 'Tabriz',
    irradianceKwhPerM2Day: 4.2,
  ),
  IranCity(
    id: 'ahvaz',
    nameFa: 'اهواز',
    nameEn: 'Ahvaz',
    irradianceKwhPerM2Day: 5.8,
  ),
  IranCity(
    id: 'kerman',
    nameFa: 'کرمان',
    nameEn: 'Kerman',
    irradianceKwhPerM2Day: 5.6,
  ),
  IranCity(
    id: 'yazd',
    nameFa: 'یزد',
    nameEn: 'Yazd',
    irradianceKwhPerM2Day: 5.7,
  ),
  IranCity(
    id: 'bandar_abbas',
    nameFa: 'بندرعباس',
    nameEn: 'Bandar Abbas',
    irradianceKwhPerM2Day: 5.4,
  ),
  IranCity(
    id: 'rasht',
    nameFa: 'رشت',
    nameEn: 'Rasht',
    irradianceKwhPerM2Day: 3.8,
  ),
];

IranCity cityById(String id) =>
    iranCities.firstWhere((c) => c.id == id, orElse: () => iranCities.first);
