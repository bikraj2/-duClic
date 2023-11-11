import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:sikshya/core/common/enums/update_user.dart';
import 'package:sikshya/src/auth/data/datasources/auth_remote_data_source.dart';

void main() {
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late MockGoogleSignIn googleSignIn;
  late User? user;
  setUp(() async {
    cloudStoreClient = FakeFirebaseFirestore();
    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Sign in.
    final mockUser = MockUser(
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    authClient = MockFirebaseAuth(mockUser: mockUser);
    final result = await authClient.signInWithCredential(credential);
    user = result.user;
    
    dbClient = MockFirebaseStorage();
    dataSource = AuthRemoteDataSourceImpl(
      cloudStoreClient: cloudStoreClient,
      authClient: authClient,
      dbclient: dbClient,
    );
  });
  const tPassword = 'Test Password';
  const tFullName = 'Test FullName';
  const tEmail = 'Testemail@gmail.com';

  const newPassword = 'newPassword';
  const newDisplayName = 'newFullName';
  test(
      'should create user on the firestore and the authClient has the user when '
      'signUp is successul', () async {
    await dataSource.signUp(
      email: tEmail,
      fullName: tFullName,
      password: tPassword,
    );
    // expect that the user is created in the firestore and the authclient also
    // has this user
    expect(authClient.currentUser, isNotNull);
    expect(authClient.currentUser!.displayName, tFullName);
    final user = await cloudStoreClient
        .collection('users')
        .doc(authClient.currentUser!.uid)
        .get();
    expect(user.exists, true);
  });
  group('sigIn', () {
    test('signIn', () async {
      await dataSource.signUp(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      );
      await authClient.signOut();
      await dataSource.signUp(
        email: 'newEmail@mail.com',
        fullName: tFullName,
        password: tPassword,
      );
      await authClient.signOut();
      await dataSource.signIn(email: 'newEmail@mail.com', password: tPassword);
      expect(authClient.currentUser, isNotNull);
      expect(authClient.currentUser!.email, 'newEmail@mail.com');
    });

    group('update user', () {
      test('displayname', () async {
        await dataSource.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        );
        await dataSource.updateUser(
          action: UpdateUserAction.displayName,
          userdata: 'newDisplayName',
        );
        final updatedUser = await cloudStoreClient
            .collection('users')
            .doc(authClient.currentUser!.uid)
            .get();
        debugPrint(updatedUser.data().toString());
        expect(authClient.currentUser!.displayName, 'newDisplayName');
        expect(updatedUser.data()!['fullName'], 'newDisplayName');
      });
      test('email', () async {
        await dataSource.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        );
        await dataSource.updateUser(
          action: UpdateUserAction.email,
          userdata: 'newemail',
        );
        final updatedUser = await cloudStoreClient
            .collection('users')
            .doc(authClient.currentUser!.uid)
            .get();
        debugPrint(updatedUser.data().toString());
        expect(authClient.currentUser!.email, 'newemail');
        expect(updatedUser.get('email'), 'newemail');
      });
    });
  });
}
