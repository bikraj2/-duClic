import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikshya/core/errors/exceptions.dart';
import 'package:sikshya/src/on_boarding/data/dataSources/on_boarding_local_data_source.dart';

class MockingSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences _pref;
  late OnBoardingLocalDataSource localDataSource;
  setUp(() {
    _pref = MockingSharedPreferences();
    localDataSource = OnBoardingLocalDataSourceImpl(_pref);
  });
  group('cacheFirstTimer', () {
    test('should call[SharedPreferences]', () async {
      when(() => _pref.setBool(any(), any())).thenAnswer((_) async => true);
      await localDataSource.cacheFirstTimer();
      verify(() => _pref.setBool(kFirstTimer, false)).called(1);
      verifyNoMoreInteractions(_pref);
      // Action
      final result = _pref.getBool(kFirstTimer);
      expect(result, false);
    });
    test(
        'should throw [cacheException] when there is an error caching the data',
        () async {
      when(
        () => _pref.setBool(any(), any()),
      ).thenThrow(Exception());
      final methodCall = localDataSource.cacheFirstTimer();
      expect(methodCall, throwsA(isA<CacheException>()));
      verify(
        () => _pref.setBool(kFirstTimer, false),
      ).called(1);
      verifyNoMoreInteractions(_pref);
    });
  });
  group('checkIfUserIsFirstTimer', () {
    test('should return [true] if the user is a first timer', () async {
      when(
        () => _pref.getBool(any()),
      ).thenReturn(false);
      final result = await localDataSource.checkIfUserIsFirstTimer();
      expect(result, false);
      verify(
        () => _pref.getBool(kFirstTimer),
      );
      verifyNoMoreInteractions(_pref);
    });
    test('should return true if there is no data in the cache', () async {
      when(
        () => _pref.getBool(any()),
      ).thenReturn(null);
      final result = await localDataSource.checkIfUserIsFirstTimer();
      expect(result, true);
      verify(
        () => _pref.getBool(kFirstTimer),
      ).called(1);
      verifyNoMoreInteractions(_pref);
    });
     test(
        'should throw [cacheException] when there is an error caching the data',
        () async {
      when(
        () => _pref.getBool(any()),
      ).thenThrow(Exception());
      final methodCall = localDataSource.checkIfUserIsFirstTimer();
      expect(methodCall, throwsA(isA<CacheException>()));
      verify(
        () => _pref.getBool(kFirstTimer),
      ).called(1);
      verifyNoMoreInteractions(_pref);
    });
  });
}
