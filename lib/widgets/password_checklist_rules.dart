import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:e2e_period_tracking/widgets/password_check_indicator.dart';
import 'package:flutter/material.dart';

class PasswordChecklistRules extends StatelessWidget {
  final ValueNotifier<String> password;
  final _rules = PasswordSecurityRule.values;

  PasswordChecklistRules({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _rules.length,
      itemBuilder: (context, index) {
        return ValueListenableBuilder<String>(
          valueListenable: password,
          builder: (context, value, child) {
            return Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color:
                      _rules[index].isValid(value) ? Colors.green : Colors.grey,
                ),
                kSizeW8,
                CustomText(
                  text: _rules[index].description,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
