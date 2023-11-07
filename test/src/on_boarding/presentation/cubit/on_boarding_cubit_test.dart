import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikshya/core/errors/failures.dart';
import 'package:sikshya/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:sikshya/src/on_boarding/domain/usecases/user_is_first_timer.dart';
import 'package:sikshya/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';

class MockCacheUser extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  // on succesful cacched - emit UserCached()
  // on error caches - emit OnBoardingError(message)
  // on successfull checkofUser - emit OnBoardinStatus(result)
  // on Failure -emit OnBoardingStatus(true)
  late CacheFirstTimer _cacheFirstTimer;
  late CheckIfUserIsFirstTimer _checkUserFirstTimer;
  late OnBoardingCubit cubit;
  setUp(() {
    _cacheFirstTimer = MockCacheUser();
    _checkUserFirstTimer = MockCheckIfUserIsFirstTimer();
    cubit = OnBoardingCubit(
      checkIfUserFirstTimer: _checkUserFirstTimer,
      cacheFirstTimer: _cacheFirstTimer,
    );
  });
  test('should emit[OnBoardingInitial] when app is first loaded', () {
    expect(cubit.state, const OnBoardingInitial());
  });
  group('cacheFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'emits [CachingFirstTimer,UserCached] when successful',
      build: () {
        when(() => _cacheFirstTimer())
            .thenAnswer((invocation) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => const <OnBoardingState>[CachingFirstTimer(), UserCached()],
      verify: (bloc) {
        verify(
          () => _cacheFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(_checkUserFirstTimer);
      },
    );
    blocTest<OnBoardingCubit, OnBoardingState>(
      'emits [CachingFirstTimer,OnBoardingError] when failed',
      build: () {
        when(() => _cacheFirstTimer()).thenAnswer(
          (invocation) async => Left(
            CacheFailure(message: 'Unkown Error Occured', statusCode: 500),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => const <OnBoardingState>[
        CachingFirstTimer(),
        OnBoardingError('Unkown Error Occured'),
      ],
      verify: (bloc) {
        verify(
          () => _cacheFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(_cacheFirstTimer);
      },
    );
  });
  group('checkIfuserFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'emits [CachingFirstTimer(),OnBoardingStatus(status)] when MyEvent is added.',
      build: () {
        when(
          () => _checkUserFirstTimer(),
        ).thenAnswer((invocation) async => const Right(true));
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserFirstTimer(),
      expect: () => const <OnBoardingState>[
        CheckingIfUserFirstTimer(),
        OnBoardingStatus(isFirstTimer: true),
      ],
      verify: (_) {
        verify(
          () => _checkUserFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(_checkUserFirstTimer);
      },
    );
    blocTest<OnBoardingCubit, OnBoardingState>(
      'emits [MyState] when MyEvent is added.',
      build: () {
        when(
          () => _checkUserFirstTimer(),
        ).thenAnswer(
          (invocation) async => Left(
            CacheFailure(message: 'Unknown Error Occured', statusCode: 500),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserFirstTimer(),
      expect: () => const <OnBoardingState>[
        CheckingIfUserFirstTimer(),
        OnBoardingStatus(isFirstTimer: true),
      ],
      verify: (_) {
        verify(
          () => _checkUserFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(_checkUserFirstTimer);
      },
    );
  });
}
