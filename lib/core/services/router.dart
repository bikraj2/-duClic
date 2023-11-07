// import 'package:flutter/material.dart';
// import 'package:sikshya/src/on_boarding/presentation/on_boarding_screen.dart';

// Route<dynamic> onGenerateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case OnBoardingScreen.routeName:
//       return MaterialPageRoute(builder: (_) => OnBoardingScreen());
//       break;
//     default:
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sikshya/core/common/views/page_under_construction.dart';
import 'package:sikshya/core/services/injection_container.dart';
import 'package:sikshya/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:sikshya/src/on_boarding/presentation/views/on_boarding_screen.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) {
      return _pageBuilder(const PageUnderConstruction());
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _pageBuilder(
          BlocProvider(
            create: (context) => sl<OnBoardingCubit>(),
            child: const OnBoardingScreen(),
          ),
        ),
      ),
    ],
    // errorPageBuilder: (context, state) => MaterialPage(child: ErrorScreen()),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

CustomTransitionPage<dynamic> _pageBuilder(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, _, __, child) => FadeTransition(
      opacity: _,
      child: child,
    ),
  );
}
