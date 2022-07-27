import 'package:e2e_period_tracking/screens/mobile_unlocked_screen.dart';
import 'package:e2e_period_tracking/screens/not_found_screen.dart';
import 'package:e2e_period_tracking/screens/profile_screen.dart';
import 'package:e2e_period_tracking/screens/setup_screen.dart';
import 'package:e2e_period_tracking/screens/welcome_screen.dart';
import 'package:e2e_period_tracking/utils/auth_bloc.dart';
import 'package:e2e_period_tracking/utils/bloc_provider.dart';
import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  final prefs = await SharedPreferences.getInstance();
  final hasAlreadyPasswordSetted =
      prefs.getBool(Preferences.hasAlreadyPasswordSetted) ?? false;

  runApp(E2EPeriodTrackingApp(goToProfile: hasAlreadyPasswordSetted));
}

class E2EPeriodTrackingApp extends StatelessWidget {
  final bool goToProfile;

  const E2EPeriodTrackingApp({
    Key? key,
    required this.goToProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E2E Period Tracker',
      home: //MobileUnlockedProfile(),

          goToProfile ? ProfileScreen() : const WelcomeScreen(),
      // onGenerateRoute: AppRouter.router.generator,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const NotFoundScreen(),
      ),
    );
  }
}
