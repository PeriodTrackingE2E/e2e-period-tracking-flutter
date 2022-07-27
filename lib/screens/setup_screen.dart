import 'package:e2e_period_tracking/screens/profile_screen.dart';
import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/utils/crypto_manager.dart';
import 'package:e2e_period_tracking/utils/validator.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:e2e_period_tracking/widgets/password_check_indicator.dart';
import 'package:e2e_period_tracking/widgets/password_checklist_rules.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupScreen extends StatelessWidget {
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _listenablePasswordStatus =
      ValueNotifier<PasswordCheck>(PasswordCheck.superWeak);
  final _passListenable = ValueNotifier<String>("");
  final _confirmPassListenable = ValueNotifier<String>("");

  SetupScreen({Key? key}) : super(key: key);

  Future<void> _onValidPassword(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Preferences.hasAlreadyPasswordSetted, true);

    CryptoManager.aesPassword = _passController.text;
    await prefs.setString(
        CryptoManager.testStringPrefsKey, CryptoManager.encryptedTestString);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileScreen(aesPassword: _passController.text),
      ),
    );
  }

  bool _checkPasswordsEqual() {
    return _passController.text == _confirmPassController.text;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const CustomText(
                            text: "Choose a Password",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          kSizeH32,
                          const CustomText(
                            text:
                                "We need to create a strong password to keep your data safe and encrypted.\n\nKeep your password in a safe place, only with that will you be able to access your profile again!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          kSizeH64,
                          TextField(
                            obscureText: true,
                            controller: _passController,
                            maxLength: Validator.charNumber,
                            onChanged: (value) {
                              _passListenable.value = value;
                              _listenablePasswordStatus.value =
                                  PasswordCheck.fromPassword(value);
                            },
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: GoogleFonts.inter().copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          kSizeH16,
                          PasswordCheckIndicator(
                            passwordCheck: _listenablePasswordStatus,
                          ),
                          kSizeH16,
                          TextField(
                            obscureText: true,
                            maxLength: Validator.charNumber,
                            controller: _confirmPassController,
                            onChanged: (value) {
                              _confirmPassListenable.value = value;
                              _listenablePasswordStatus.notifyListeners();
                            },
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: GoogleFonts.inter().copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          kSizeH32,
                          PasswordChecklistRules(password: _passListenable),
                          kSizeH32,
                          ValueListenableBuilder<PasswordCheck>(
                            valueListenable: _listenablePasswordStatus,
                            builder: ((context, value, _) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 32,
                                  ),
                                ),
                                onPressed: value == PasswordCheck.superStrong &&
                                        _checkPasswordsEqual()
                                    ? () async =>
                                        await _onValidPassword(context)
                                    : null,
                                child: const CustomText(
                                  text: "LET'S START",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
