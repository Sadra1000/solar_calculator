/// Validates the appliance catalog JSON shape before parsing models.
class AppliancesSchema {
  static void validate(dynamic json) {
    if (json is! List<dynamic>) {
      throw const FormatException('Appliance catalog root must be a JSON array');
    }

    for (var i = 0; i < json.length; i++) {
      _validateCategory(json[i], index: i);
    }
  }

  static void _validateCategory(dynamic value, {required int index}) {
    if (value is! Map<String, dynamic>) {
      throw FormatException('Category at index $index must be an object');
    }

    final icon = value['icon'];
    if (icon is! int) {
      throw FormatException('Category at index $index: "icon" must be an integer');
    }

    final name = value['name'];
    if (name is! String || name.isEmpty) {
      throw FormatException(
        'Category at index $index: "name" must be a non-empty string',
      );
    }

    final subCategories = value['sub_categories'];
    if (subCategories is! List<dynamic>) {
      throw FormatException(
        'Category at index $index: "sub_categories" must be an array',
      );
    }

    for (var j = 0; j < subCategories.length; j++) {
      _validateAppliance(subCategories[j], categoryIndex: index, itemIndex: j);
    }
  }

  static void _validateAppliance(
    dynamic value, {
    required int categoryIndex,
    required int itemIndex,
  }) {
    if (value is! Map<String, dynamic>) {
      throw FormatException(
        'Appliance at category $categoryIndex, item $itemIndex must be an object',
      );
    }

    final name = value['name'];
    if (name is! String || name.isEmpty) {
      throw FormatException(
        'Appliance at category $categoryIndex, item $itemIndex: '
        '"name" must be a non-empty string',
      );
    }

    final powerUsage = value['power_usage'];
    if (powerUsage is! int || powerUsage <= 0) {
      throw FormatException(
        'Appliance at category $categoryIndex, item $itemIndex: '
        '"power_usage" must be a positive integer',
      );
    }

    final hours = value['hours'];
    if (hours is! num || hours <= 0) {
      throw FormatException(
        'Appliance at category $categoryIndex, item $itemIndex: '
        '"hours" must be a positive number',
      );
    }
  }
}
