import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikshya/core/errors/exceptions.dart';

const kFirstTimer = 'first_timer';

abstract class OnBoardingLocalDataSource {
  const OnBoardingLocalDataSource();
  Future<void> cacheFirstTimer();
  Future<bool> checkIfUserIsFirstTimer();
}

class OnBoardingLocalDataSourceImpl extends OnBoardingLocalDataSource {
  const OnBoardingLocalDataSourceImpl(this._pref);
  final SharedPreferences _pref;
  @override
  Future<void> cacheFirstTimer() async {
    try {
      await _pref.setBool(kFirstTimer, false);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTimer() async {
    try {
      final value = _pref.getBool(kFirstTimer);
      return value ?? true;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
