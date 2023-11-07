import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sikshya/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:sikshya/src/on_boarding/domain/usecases/user_is_first_timer.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit({
    required CheckIfUserIsFirstTimer checkIfUserFirstTimer,
    required CacheFirstTimer cacheFirstTimer,
  })  : _cacheFirstTimer = cacheFirstTimer,
        _checkIfUserFirstTimer = checkIfUserFirstTimer,
        super(const OnBoardingInitial());

  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserIsFirstTimer _checkIfUserFirstTimer;
  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimer());
    final result = await _cacheFirstTimer();
    result.fold(
      (l) => emit(OnBoardingError(l.message)),
      (r) => emit(
        const UserCached(),
      ),
    );
  }

  Future<void> checkIfUserFirstTimer() async {
    emit(const CheckingIfUserFirstTimer());
    final result = await _checkIfUserFirstTimer();
    result.fold(
      (l) => emit(const OnBoardingStatus(isFirstTimer: true)),
      (r) => emit(OnBoardingStatus(isFirstTimer: r)),
    );
  }
}
