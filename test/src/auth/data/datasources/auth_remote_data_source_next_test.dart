import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikshya/core/common/enums/update_user.dart';
import 'package:sikshya/core/errors/exceptions.dart';
import 'package:sikshya/core/res/media_res.dart';
import 'package:sikshya/core/utils/contants.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sikshya/src/auth/data/models/user_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (user != null) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbclient;
  late AuthRemoteDataSource dataSource;
  late UserCredential userCredential;
  late MockUser mockUser;
  late DocumentReference<DataMap> docRef;
  const tUser = LocalUserModel.empty();

  const tPassword = 'Test Password';
  const tFullName = 'Test FullName';
  const tEmail = 'Testemail@gmail.com';

  const newPassword = 'newPassword';
  const newDisplayName = 'newFullName';
  const newEmail = 'newEmail@mail.com';

  final tFirebaseException = FirebaseException(
      plugin: 'email',
      code: 'user-not-found',
      message: 'There is no reord of the user in our database.');
  setUpAll(() async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    dbclient = MockFirebaseStorage();

    docRef = cloudStoreClient.collection('users').doc();
    await docRef.set(tUser.copyWith(uid: docRef.id).toMap());
    mockUser = MockUser()..uid = docRef.id;
    userCredential = MockUserCredential(mockUser);
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbclient: dbclient,
    );
    when(
      () => authClient.currentUser,
    ).thenReturn(mockUser);
  });

  // ForgotPassword

  group('forgot Password', () {
    test('should compelete successfully when no exeception is thrown',
        () async {
      when(
        () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
      ).thenAnswer(
        (_) async => Future.value,
      );

      final call = dataSource.forgotPassword(tEmail);
      expect(call, completes);
      verify(
        () => authClient.sendPasswordResetEmail(email: tEmail),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });
    test('should throw an [ServerException] when there is an erro', () async {
      when(
        () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
      ).thenThrow(
        tFirebaseException,
      );
      final call = dataSource.forgotPassword;
      expect(
        () => call(tEmail),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => authClient.sendPasswordResetEmail(email: tEmail),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });
  group('signIn', () {
    test('should Return a [LocalUseModel] when no Exception is thrown',
        () async {
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => userCredential);

      final result =
          await dataSource.signIn(email: tEmail, password: tPassword);
      expect(result.uid, equals(userCredential.user!.uid));
      expect(result.points, 0);
      verify(
        () => authClient.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test('should throw an [ServerException] when there is an erro', () async {
      when(
        () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password')),
      ).thenThrow(
        tFirebaseException,
      );
      final call = dataSource.signIn;
      expect(
        () => call(email: tEmail, password: tPassword),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => authClient.signInWithEmailAndPassword(
            email: tEmail, password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });
    test('should throw an [ServerException] when there is an erro', () async {
      final tUserCredential = MockUserCredential();
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => tUserCredential);

      final call = dataSource.signIn;
      expect(
        () => call(email: tEmail, password: tPassword),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => authClient.signInWithEmailAndPassword(
            email: tEmail, password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });
  group('signUp', () {
    setUp(() {});
    test('should complete Succesfully when there is no Erro', () async {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => userCredential);
      when(
        () => userCredential.user!.updateDisplayName(any()),
      ).thenAnswer((_) async => Future.value);
      when(
        () => userCredential.user!.updatePhotoURL(any()),
      ).thenAnswer((_) async => Future.value);
      //
      final call = dataSource.signUp(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      );
      expect(call, completes);

      // await untilcalled
      await untilCalled(
        () => userCredential.user?.updateDisplayName(any()),
      );
      await untilCalled(
        () => userCredential.user?.updatePhotoURL(any()),
      );

      verify(
        () => authClient.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verify(() => userCredential.user?.updateDisplayName(tFullName)).called(1);
      verify(
        () => userCredential.user?.updatePhotoURL(kDefaultAvatar),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException);

      final call = dataSource.signUp;
      expect(
        () => call(email: tEmail, password: tPassword, fullName: tFullName),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => authClient.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
    });
  });
  group('upDate user', () {
    setUp(() {
      when(
        () => authClient.currentUser,
      ).thenReturn(mockUser);
      registerFallbackValue(MockAuthCredential());
    });
    test('should Update user when no [Execption]', () async {
      when(
        () => mockUser.updateDisplayName(any()),
      ).thenAnswer((_) async => Future.value);

      final call = dataSource.updateUser(
        action: UpdateUserAction.displayName,
        userdata: tFullName,
      );
      expect(call, completes);
      verify(
        () => mockUser.updateDisplayName(tFullName),
      ).called(1);

      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      verifyNever(() => mockUser.updatePhotoURL(any()));

      final user =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();

      expect(user.data()!['fullName'], equals(tFullName));
    });
    test('should update user password when no [Exception Occurs]', () async {
      when(() => mockUser.updatePassword(any()))
          .thenAnswer((_) async => Future.value);
      when(() => mockUser.reauthenticateWithCredential(any()))
          .thenAnswer((_) async => userCredential);
      when(() => mockUser.email).thenReturn(tEmail);

      final call = dataSource.updateUser(
        action: UpdateUserAction.password,
        userdata: jsonEncode({
          'oldPassword': 'oldPassword',
          'newPassword': tPassword,
        }),
      );

      expect(call, completes);
      verify(() => mockUser.reauthenticateWithCredential(any())).called(1);
      verify(() => mockUser.updatePassword(tPassword)).called(1);
    });
  });

  test('should updare user ', () async {
    final newProfileFile = File(MediaRes.casualReading);
    when(
      () => mockUser.updatePhotoURL(any()),
    ).thenAnswer((invocation) async => Future.value());
    await dataSource.updateUser(
        action: UpdateUserAction.profilePic, userdata: newProfileFile);
    verify(() => mockUser.updatePhotoURL(any()));
    expect(dbclient.storedFilesMap.isNotEmpty, isTrue);
  });
}
