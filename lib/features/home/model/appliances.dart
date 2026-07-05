// ignore_for_file: public_member_api_docs, sort_constructors_first
// lib/core/models/appliance.dart (or any other path)

class AppliancesCatgory {
  final int icon;
  final String name;
  final List<Appliance> appliance;

  AppliancesCatgory({
    required this.icon,
    required this.name,
    required this.appliance,
  });

  factory AppliancesCatgory.fromMap(Map<String, dynamic> map) {
    return AppliancesCatgory(
      icon: map["icon"] as int,
      name: map['name'] as String,
      appliance: List<Appliance>.from(
        (map['sub_categories'] as List<dynamic>).map<Appliance>(
          (x) =>
              Appliance.fromMap(x as Map<String, dynamic>, map["icon"] as int),
        ),
      ),
    );
  }
}

class Appliance {
  final int icon;
  final String name;
  final int powerUsage;
  final double houres;
  const Appliance({
    required this.powerUsage,
    required this.houres,
    required this.icon,
    required this.name,
  });

  Appliance copyWith({
    int? icon,
    String? name,
    int? powerUsage,
    double? houres,
  }) {
    return Appliance(
      icon: icon ?? this.icon,
      name: name ?? this.name,
      powerUsage: powerUsage ?? this.powerUsage,
      houres: houres ?? this.houres,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'icon': icon,
      'name': name,
      'powerUsage': powerUsage,
      'houres': houres,
    };
  }

  factory Appliance.fromMap(Map<String, dynamic> map, int icon) {
    return Appliance(
      icon: icon,
      name: map['name'] as String,
      powerUsage: map['power_usage'] as int,
      houres: (map['hours'] as num).toDouble(),
    );
  }

  factory Appliance.fromStoredMap(Map<String, dynamic> map) {
    return Appliance(
      icon: map['icon'] as int,
      name: map['name'] as String,
      powerUsage: map['powerUsage'] as int,
      houres: (map['houres'] as num).toDouble(),
    );
  }
}

extension ApplianceX on Appliance {
  // برای گروه‌بندی بر اساس نام
  String get key => name.trim();
}
