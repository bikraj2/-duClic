import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sikshya/core/errors/failures.dart';
import 'package:sikshya/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:sikshya/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:sikshya/src/on_boarding/domain/usecases/user_is_first_timer.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo _repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    _repo = MockOnBoarding();
    usecase = CheckIfUserIsFirstTimer(_repo);
  });
  test(
      'should call the [OnBoardingRepo.CheckIfUserIsFirstTimer] and '
      'return true', () async {
    when(() => _repo.checkIfUserIsFirstTime()).thenAnswer(
      (invocation) async => right(true),
    );
    final result = await usecase();
    expect(
      result,
      equals(
        right<Failure, bool>(true),
      ),
    );
    verify(() => _repo.checkIfUserIsFirstTime()).called(1);

    verifyNoMoreInteractions(_repo);
  });
}
