import 'package:sikshya/core/usecases/usecases.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/on_boarding/domain/repos/on_boarding_repo.dart';

class CheckIfUserIsFirstTimer extends UseCaseWithOutParams<bool> {
  const CheckIfUserIsFirstTimer(this._repo);
  final OnBoardingRepo _repo;
  @override
  ResultFuture<bool> call() => _repo.checkIfUserIsFirstTime();
}
