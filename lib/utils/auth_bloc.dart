import 'package:e2e_period_tracking/utils/bloc_provider.dart';
import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable

class AuthBLoC with ChangeNotifier implements Bloc {
  bool _hasAlreadyPasswordSetted = false;
  bool get hasAlreadyPasswordSetted => _hasAlreadyPasswordSetted;

  set hasAlreadyPasswordSetted(bool value) {
    _hasAlreadyPasswordSetted = value;
    notifyListeners();
  }

  AuthBLoC() {
    _init();
  }

  _init() async {
    final prefs = await SharedPreferences.getInstance();

    hasAlreadyPasswordSetted =
        prefs.getBool(Preferences.hasAlreadyPasswordSetted) ?? false;
  }
}
