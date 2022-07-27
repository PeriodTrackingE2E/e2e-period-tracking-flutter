import 'package:e2e_period_tracking/screens/not_found_screen.dart';
import 'package:e2e_period_tracking/screens/profile_screen.dart';
import 'package:e2e_period_tracking/screens/setup_screen.dart';
import 'package:e2e_period_tracking/screens/welcome_screen.dart';
import 'package:e2e_period_tracking/utils/auth_bloc.dart';
import 'package:fluro/fluro.dart';

// class AppRouter {
//   static final router = FluroRouter();
//   static late final AuthBLoC authBloc;

//   static void setupRouter() {
//     router.define(
//       '/',
//       handler: Handler(handlerFunc: (_, __) => const WelcomeScreen()),
//       transitionType: TransitionType.native,
//     );

//     router.define(
//       '/setup',
//       handler: Handler(handlerFunc: (_, __) => const SetupScreen()),
//       transitionType: TransitionType.native,
//     );
//     router.define(
//       '/profile',
//       handler: Handler(handlerFunc: (_, __) => const ProfileScreen()),
//       transitionType: TransitionType.native,
//     );

//     router.notFoundHandler = Handler(handlerFunc: (_, __) => const NotFoundScreen());
//   }
// }
