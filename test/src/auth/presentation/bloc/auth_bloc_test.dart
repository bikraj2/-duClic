import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sikshya/core/errors/failures.dart';
import 'package:sikshya/src/auth/domain/entities/user.dart';

import 'package:sikshya/src/auth/domain/usecases/forgot_password.dart';
import 'package:sikshya/src/auth/domain/usecases/sign_in.dart';
import 'package:sikshya/src/auth/domain/usecases/sign_up.dart';
import 'package:sikshya/src/auth/domain/usecases/update_user.dart';
import 'package:sikshya/src/auth/presentation/bloc/auth_bloc.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgetPassword extends Mock implements ForgetPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgetPassword forgetPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tSignInParms = SignInParams.empty();
  const tForgetPassowrd = ForgotPasswordParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();

  final tServerFailure = ApiFailure(
    message: 'incorret email',
    statusCode: '-user-not-found',
  );
  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgetPassword = MockForgetPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgetPassword: forgetPassword,
      updateUser: updateUser,
    );
  });

  setUpAll(() {
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tSignInParms);
    registerFallbackValue(tForgetPassowrd);
    registerFallbackValue(tUpdateUserParams);
  });
  tearDown(() => authBloc.close);

  test('initial state should be [AuthInitial]', () {
    expect(authBloc.state, const AuthInitial());
  });

  group('SignInEvent', () {
    const tUser = LocalUser.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoadin, SignedIn] when [SignInEvent] is added',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer((invocation) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignInEvent(
            email: tSignInParms.email,
            password: tSignInParms.password,
          ),
        );
      },
      expect: () => [const AuthLoading(), const SignedIn(tUser)],
      verify: (bloc) {
        verify(
          () => signIn(
            SignInParams(
                email: tSignInParms.email, password: tSignInParms.password),
          ),
        ).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoadin, AuthFailure] when [SignInEvent] is added and '
      'faiure occurs',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignInEvent(
            email: tSignInParms.email,
            password: tSignInParms.password,
          ),
        );
      },
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (bloc) {
        verify(
          () => signIn(
            SignInParams(
                email: tSignInParms.email, password: tSignInParms.password),
          ),
        ).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });
  group('SignUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should return [AuthLoading, SignedUp]',
      build: () {
        when(
          () => signUp(tSignUpParams),
        ).thenAnswer((invocation) async => const Right(null));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            fullName: tSignUpParams.fullName,
          ),
        );
      },
      expect: () => [const AuthLoading(), const SignedUp()],
      verify: (bloc) {
        verify(
          () => signUp(tSignUpParams),
        );
      },
    );
    blocTest<AuthBloc, AuthState>(
      'should return [AuthLoading, AuthError]',
      build: () {
        when(
          () => signUp(tSignUpParams),
        ).thenAnswer((invocation) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            fullName: tSignUpParams.fullName,
          ),
        );
      },
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (bloc) {
        verify(
          () => signUp(tSignUpParams),
        );
      },
    );
  });
  group('ForgetPassowrd', () {
    blocTest<AuthBloc, AuthState>(
      'should return [AuthLoading, ForgotPassowrd]',
      build: () {
        when(
          () => forgetPassword(tForgetPassowrd),
        ).thenAnswer((invocation) async => const Right(null));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          ForgotPasswordEvent(tForgetPassowrd.email),
        );
      },
      expect: () => [const AuthLoading(), const ForgotPasswordSent()],
      verify: (bloc) {
        verify(
          () => forgetPassword(tForgetPassowrd),
        );
      },
    );
    blocTest<AuthBloc, AuthState>(
      'should return [AuthLoading, AuthError]',
      build: () {
        when(
          () => forgetPassword(any()),
        ).thenAnswer((invocation) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          ForgotPasswordEvent(tForgetPassowrd.email),
        );
      },
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (bloc) {
        verify(
          () => forgetPassword(tForgetPassowrd),
        );
      },
    );
  });
  group('UpdatePassword', () {
    blocTest<AuthBloc, AuthState>(
      'should return [AuthLoading, UserUpdated]',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer((invocation) async => const Right(null));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          UpdateUserEvent(
            action: tUpdateUserParams.action,
            userdata: tUpdateUserParams.userData,
          ),
        );
      },
      expect: () => [const AuthLoading(), const UserUpdated()],
      verify: (bloc) {
        verify(
          () => updateUser(tUpdateUserParams),
        );
      },
    );
    blocTest<AuthBloc, AuthState>(
      'should return [AuthLoading, AuthError]',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer((invocation) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          UpdateUserEvent(
            action: tUpdateUserParams.action,
            userdata: tUpdateUserParams.userData,
          ),
        );
      },
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (bloc) {
        verify(
          () => updateUser(tUpdateUserParams),
        );
      },
    );
  });
}
