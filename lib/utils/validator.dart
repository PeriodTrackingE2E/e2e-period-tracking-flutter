class Validator {
  static const int charNumber = 16;

  final RegExp _numberRegExp = RegExp(r'[0-9]');
  final RegExp _specialRegExp = RegExp(r'[!@#$%^&*()?":{}|<>]');
  final RegExp _lowercaseRegExp = RegExp(r'[a-z]');
  final RegExp _uppercaseRegExp = RegExp(r'[A-Z]');

  bool isValidPassword(String password) {
    return password.isNotEmpty &&
        hasAlmostOneNumber(password) &&
        hasAlmostOneSpecialChar(password) &&
        hasAlmostOneLowercase(password) &&
        hasAlmostOneUppercase(password) &&
        hasMinimumCharNumber(password);
  }

  bool hasAlmostOneNumber(String password) {
    return _numberRegExp.hasMatch(password);
  }

  bool hasAlmostOneSpecialChar(String password) {
    return _specialRegExp.hasMatch(password);
  }

  bool hasAlmostOneLowercase(String password) {
    return _lowercaseRegExp.hasMatch(password);
  }

  bool hasAlmostOneUppercase(String password) {
    return _uppercaseRegExp.hasMatch(password);
  }

  bool hasMinimumCharNumber(String password) {
    return password.length >= charNumber;
  }
}
