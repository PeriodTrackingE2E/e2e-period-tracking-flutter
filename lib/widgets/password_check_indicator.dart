import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/utils/validator.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:flutter/material.dart';

enum PasswordSecurityRule {
  almostOneNumber,
  almostOneUpperCase,
  almostOneLowerCase,
  almostOneSpecialCharacter,
  minimumLength;

  String get description {
    switch (this) {
      case PasswordSecurityRule.almostOneNumber:
        return "At least one number";
      case PasswordSecurityRule.almostOneUpperCase:
        return "At least one upper case";
      case PasswordSecurityRule.almostOneLowerCase:
        return "At least one lower case";
      case PasswordSecurityRule.almostOneSpecialCharacter:
        return "At least one special character";
      case PasswordSecurityRule.minimumLength:
        return "Length of ${Validator.charNumber} characters";
    }
  }

  bool isValid(String password) {
    final validator = Validator();
    switch (this) {
      case PasswordSecurityRule.almostOneNumber:
        return validator.hasAlmostOneNumber(password);
      case PasswordSecurityRule.almostOneUpperCase:
        return validator.hasAlmostOneUppercase(password);
      case PasswordSecurityRule.almostOneLowerCase:
        return validator.hasAlmostOneLowercase(password);
      case PasswordSecurityRule.almostOneSpecialCharacter:
        return validator.hasAlmostOneSpecialChar(password);
      case PasswordSecurityRule.minimumLength:
        return validator.hasMinimumCharNumber(password);
    }
  }
}

enum PasswordCheck {
  superWeak,
  weak,
  medium,
  strong,
  superStrong;

  static PasswordCheck fromPassword(String inputPassword) {
    final validator = Validator();
    var counter = 0;

    if (validator.isValidPassword(inputPassword)) {
      return PasswordCheck.superStrong;
    }

    if (validator.hasAlmostOneNumber(inputPassword)) {
      counter++;
    }

    if (validator.hasAlmostOneSpecialChar(inputPassword)) {
      counter++;
    }

    if (validator.hasAlmostOneLowercase(inputPassword)) {
      counter++;
    }

    if (validator.hasAlmostOneUppercase(inputPassword)) {
      counter++;
    }

    if (validator.hasMinimumCharNumber(inputPassword)) {
      counter++;
    }

    switch (counter) {
      case 2:
        return PasswordCheck.weak;
      case 3:
        return PasswordCheck.medium;
      case 4:
        return PasswordCheck.strong;
      case 5:
        return PasswordCheck.superStrong;
      default:
        return PasswordCheck.superWeak;
    }
  }

  String get description {
    switch (this) {
      case PasswordCheck.superWeak:
        return "Super weak..";
      case PasswordCheck.weak:
        return "Weak";
      case PasswordCheck.medium:
        return "Quite good";
      case PasswordCheck.strong:
        return "That's strong!";
      case PasswordCheck.superStrong:
        return "Super strong!";
    }
  }

  Color get color {
    switch (this) {
      case PasswordCheck.superWeak:
        return Color.fromARGB(255, 220, 33, 20);
      case PasswordCheck.weak:
        return Colors.redAccent;
      case PasswordCheck.medium:
        return Color.fromARGB(255, 231, 210, 23);
      case PasswordCheck.strong:
        return Colors.green;
      case PasswordCheck.superStrong:
        return Color.fromARGB(255, 24, 86, 26);
    }
  }

  double get indicatorRatio {
    switch (this) {
      case PasswordCheck.superWeak:
        return 0.1;
      case PasswordCheck.weak:
        return 0.2;
      case PasswordCheck.medium:
        return 0.55;
      case PasswordCheck.strong:
        return 0.7;
      case PasswordCheck.superStrong:
        return 1;
    }
  }
}

class PasswordCheckIndicator extends StatelessWidget {
  final ValueNotifier<PasswordCheck> passwordCheck;

  const PasswordCheckIndicator({Key? key, required this.passwordCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Row(
          children: [
            ValueListenableBuilder<PasswordCheck>(
              valueListenable: passwordCheck,
              builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      height: 10,
                      width: maxWidth * value.indicatorRatio,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: value.color,
                      ),
                      duration: const Duration(milliseconds: 400),
                    ),
                    kSizeH8,
                    CustomText(
                      text: value.description,
                      style: TextStyle(color: value.color),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
