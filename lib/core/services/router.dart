import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikshya/core/common/views/page_under_construction.dart';
import 'package:sikshya/core/extenions/context_extensions.dart';
import 'package:sikshya/core/services/injection_container.dart';
import 'package:sikshya/src/auth/data/models/user_model.dart';
import 'package:sikshya/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:sikshya/src/auth/presentation/views/forget_password.dart';
import 'package:sikshya/src/auth/presentation/views/sign_in.dart';
import 'package:sikshya/src/auth/presentation/views/sign_up.dart';
import 'package:sikshya/src/dashboard/presentation/dashboard.dart';
import 'package:sikshya/src/on_boarding/data/dataSources/on_boarding_local_data_source.dart';

import 'package:sikshya/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:sikshya/src/on_boarding/presentation/views/on_boarding_screen.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      errorPageBuilder: (context, state) {
        return _pageBuilder(const PageUnderConstruction());
      },
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            final prefs = sl<SharedPreferences>();
            if (prefs.getBool(kFirstTimer) ?? true) {
              return _pageBuilder(
                BlocProvider(
                  create: (context) => sl<OnBoardingCubit>(),
                  child: const OnBoardingScreen(),
                ),
              );
            } else if (sl<FirebaseAuth>().currentUser != null) {
              final user = sl<FirebaseAuth>().currentUser!;
              final localUser = LocalUserModel(
                uid: user.uid,
                email: user.email ?? '',
                points: 0,
                fullName: user.displayName ?? '',
              );
              context.userProvider.initUser(localUser);
              return _pageBuilder(const DashBoardScreen());
            }
            return _pageBuilder(
              BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignInScreen(),
              ),
            );
          },
        ),
        GoRoute(
          path: '/signIn',
          pageBuilder: (context, state) => _pageBuilder(
            BlocProvider(
              create: (_) => sl<AuthBloc>(),
              child: const SignInScreen(),
            ),
          ),
        ),
        GoRoute(
          path: '/signUp',
          pageBuilder: (context, state) => _pageBuilder(
            BlocProvider(
              create: (_) => sl<AuthBloc>(),
              child: const SignUpScreen(),
            ),
          ),
        ),
        GoRoute(
          path: '/forgetPassword',
          pageBuilder: (context, state) => _pageBuilder(
            BlocProvider(
              create: (_) => sl<AuthBloc>(),
              child: const ForgetPasswordScreen(),
            ),
          ),
        ),
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) =>
              _pageBuilder(const DashBoardScreen()),
        ),
      ],
      redirect: (context, state) {},
      refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream)
      // errorPageBuilder: (context, state) => MaterialPage(child: ErrorScreen(),),
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
