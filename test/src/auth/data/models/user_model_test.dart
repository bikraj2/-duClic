import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/auth/data/models/user_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();
  final tMap = jsonDecode(fixture('users.json')) as DataMap;
  test('should return  a valid [LocalUserModel] from the map', () {
    final result = LocalUserModel.fromMap(tMap);
    expect(result, isA<LocalUserModel>());
    expect(result, equals(tLocalUserModel));
  });
  group('toMap', () {
    test("shoudl return a valid [DatMap]", () {
      final result = tLocalUserModel.toMap();
      expect(result, tMap);
    });
  });
}
