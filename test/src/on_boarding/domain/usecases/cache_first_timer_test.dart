import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikshya/core/errors/exceptions.dart';
import 'package:sikshya/core/errors/failures.dart';
import 'package:sikshya/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:sikshya/src/on_boarding/domain/usecases/cache_first_timer.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo _repo;
  late CacheFirstTimer usecase;

  setUp(() {
    _repo = MockOnBoarding();
    usecase = CacheFirstTimer(_repo);
  });
  test(
      'should call the [OnBoardingRepo.cacheFirstTimer] and returh the right data',
      () async {
    when(() => _repo.cacheFirstTimer()).thenAnswer(
      (invocation) async => left(
        ApiFailure(
          message: 'Unknown error Occured',
          statusCode: 500,
        ),
      ),
    );
    final result = await usecase();
    expect(
      result,
      equals(
        left<Failure, dynamic>(
          ApiFailure(
            message: 'Unknown error Occured',
            statusCode: 500,
          ),
        ),
      ),
    );
    verify(() => _repo.cacheFirstTimer()).called(1);

    verifyNoMoreInteractions(_repo);
  });
}
