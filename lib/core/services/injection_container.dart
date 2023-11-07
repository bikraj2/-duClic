import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikshya/src/on_boarding/data/dataSources/on_boarding_local_data_source.dart';
import 'package:sikshya/src/on_boarding/data/repos/on_boarding_repo_implementation.dart';
import 'package:sikshya/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:sikshya/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:sikshya/src/on_boarding/domain/usecases/user_is_first_timer.dart';
import 'package:sikshya/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';

final sl = GetIt.instance;
Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  // Feature --> OnBoarding Feature
  // Business Logic
  sl
    ..registerFactory(
      () => OnBoardingCubit(checkIfUserFirstTimer: sl(), cacheFirstTimer: sl()),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => prefs);
}
