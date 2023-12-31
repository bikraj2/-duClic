import 'package:dartz/dartz.dart';
import 'package:sikshya/core/errors/exceptions.dart';
import 'package:sikshya/core/errors/failures.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/on_boarding/data/dataSources/on_boarding_local_data_source.dart';
import 'package:sikshya/src/on_boarding/domain/repos/on_boarding_repo.dart';

class OnBoardingRepoImpl implements OnBoardingRepo {
  const OnBoardingRepoImpl(this._localDataSource);
  final OnBoardingLocalDataSource _localDataSource;

  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      await _localDataSource.cacheFirstTimer();
      return const Right(null);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTime() async {
    try {
      final result = await _localDataSource.checkIfUserIsFirstTimer();
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
