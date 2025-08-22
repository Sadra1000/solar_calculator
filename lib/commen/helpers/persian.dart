extension PersianDigits on String {
  String toPersianDigits() {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var out = this;
    for (var i = 0; i < english.length; i++) {
      out = out.replaceAll(english[i], persian[i]);
    }
    return out;
  }

  String toWhPersian() {
    var out = this;
    return '${out.toString().toPersianDigits()}Wh';
  }

  String tokWhPersian() {
    var out = this;
    return '${out.toString().toPersianDigits()}kWh';
  }

  String tokWPersian() {
    var out = this;
    return '${out.toString().toPersianDigits()}kW';
  }

  String tokgPersian() {
    var out = this;
    return '${out.toString().toPersianDigits()}kg';
  }
}
