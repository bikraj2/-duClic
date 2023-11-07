import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikshya/core/errors/exceptions.dart';
import 'package:sikshya/core/errors/failures.dart';
import 'package:sikshya/src/on_boarding/data/dataSources/on_boarding_local_data_source.dart';
import 'package:sikshya/src/on_boarding/data/repos/on_boarding_repo_implementation.dart';
import 'package:sikshya/src/on_boarding/domain/repos/on_boarding_repo.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource _localDataSource;
  late OnBoardingRepoImpl repoImpl;
  setUp(() {
    _localDataSource = MockOnBoardingLocalDataSrc();
    repoImpl = OnBoardingRepoImpl(_localDataSource);
  });

  test('should be a subclass of OnBoardingRepo', () {
    expect(repoImpl, isA<OnBoardingRepo>);
  });

  group('CacheFirstTimer', () {
    test('should complete successfully when call to local source is successful',
        () async {
      when(
        () => _localDataSource.cacheFirstTimer(),
      ).thenAnswer((invocation) async => Future.value());
      final result = repoImpl.cacheFirstTimer();
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => _localDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(_localDataSource);
    });
    test('should return[CacheFirstFailure]', () async {
      when(
        () => _localDataSource.cacheFirstTimer(),
      ).thenThrow(
        const CacheException(
          message: 'Insufficient Storage',
        ),
      );
      final result = await repoImpl.cacheFirstTimer();
      expect(
        result,
        left<CacheException, dynamic>(
          const CacheException(message: 'Insufficient Storage'),
        ),
      );
    });
  });
}
