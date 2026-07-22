class AppliancesCategory {
  final String id;
  final int icon;
  final String nameFa;
  final String nameEn;
  final List<Appliance> appliances;

  const AppliancesCategory({
    required this.id,
    required this.icon,
    required this.nameFa,
    required this.nameEn,
    required this.appliances,
  });

  String localizedName(String languageCode) =>
      languageCode == 'fa' ? nameFa : nameEn;
}

class Appliance {
  final String id;
  final int icon;
  final String nameFa;
  final String nameEn;
  final int powerUsage;
  final double houres;

  const Appliance({
    required this.id,
    required this.icon,
    required this.nameFa,
    required this.nameEn,
    required this.powerUsage,
    required this.houres,
  });

  String localizedName(String languageCode) =>
      languageCode == 'fa' ? nameFa : nameEn;

  Appliance copyWith({
    String? id,
    int? icon,
    String? nameFa,
    String? nameEn,
    int? powerUsage,
    double? houres,
  }) {
    return Appliance(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      nameFa: nameFa ?? this.nameFa,
      nameEn: nameEn ?? this.nameEn,
      powerUsage: powerUsage ?? this.powerUsage,
      houres: houres ?? this.houres,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'icon': icon,
      'nameFa': nameFa,
      'nameEn': nameEn,
      'powerUsage': powerUsage,
      'houres': houres,
    };
  }

  factory Appliance.fromStoredMap(Map<String, dynamic> map) {
    return Appliance(
      id: map['id'] as String,
      icon: map['icon'] as int,
      nameFa: map['nameFa'] as String,
      nameEn: map['nameEn'] as String,
      powerUsage: map['powerUsage'] as int,
      houres: (map['houres'] as num).toDouble(),
    );
  }

  factory Appliance.custom({
    required int icon,
    required String name,
    required int powerUsage,
    required double houres,
  }) {
    final trimmed = name.trim();
    return Appliance(
      id: 'custom_${trimmed.hashCode}_$icon',
      icon: icon,
      nameFa: trimmed,
      nameEn: trimmed,
      powerUsage: powerUsage,
      houres: houres,
    );
  }
}

extension ApplianceX on Appliance {
  String get key => id;
}
