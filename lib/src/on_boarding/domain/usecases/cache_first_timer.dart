import 'package:sikshya/core/usecases/usecases.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/on_boarding/domain/repos/on_boarding_repo.dart';

class CacheFirstTimer extends UseCaseWithOutParams<void> {
  const CacheFirstTimer(this._repo);
  final OnBoardingRepo _repo;
  @override
  ResultFuture<void> call() async => _repo.cacheFirstTimer();
}
