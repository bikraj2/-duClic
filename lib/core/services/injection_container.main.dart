part of 'injection_container.dart';

final sl = GetIt.instance;
Future<void> init() async {
  await _initOnBoardingInit();
  await _initOnauthInit();
}

Future<void> _initOnBoardingInit() async {
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

Future<void> _initOnauthInit() async {
  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgetPassword: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton(() => ForgetPassword(sl()))
    ..registerLazySingleton<AuthRepo>(
        () => AuthRepoImpl(remoteDataSource: sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
              authClient: sl(),
              cloudStoreClient: sl(),
              dbclient: sl(),
            ))
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance);
}
