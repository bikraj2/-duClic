import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:sikshya/core/common/enums/update_user.dart';
import 'package:sikshya/core/errors/exceptions.dart';
import 'package:sikshya/core/utils/contants.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgotPassword(String email);

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userdata,
  });

  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(
      {required FirebaseAuth authClient,
      required FirebaseFirestore cloudStoreClient,
      required FirebaseStorage dbclient})
      : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbclient = dbclient;
  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbclient;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'error occured',
        statusCode: e.code,
      );
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null) {
        throw const ServerException(
            message: 'Please Try again', statusCode: 500);
      }
      var userData = await _getUserData(user.uid);
      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }
      await _setUserData(user, email);
      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final userCreds = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCreds.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please Try again',
          statusCode: 500,
        );
      }
      await user.updateDisplayName(fullName);
      await user.updatePhotoURL(kDefaultAvatar);

      await _setUserData(user, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userdata,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _authClient.currentUser?.updateEmail(userdata as String);
          await _updateUser({'email': userdata});
        case UpdateUserAction.displayName:
          await _authClient.currentUser?.updateDisplayName(userdata as String);
          await _updateUser({'fullName': userdata});
          print('here');
        case UpdateUserAction.profilePic:
          final ref = _dbclient
              .ref()
              .child('profilePics/${_authClient.currentUser?.uid}');
          await ref.putFile(userdata as File);
          final url = await ref.getDownloadURL();
          await _authClient.currentUser?.updatePhotoURL(url);
          await _updateUser({'profilePic': url});
        // for Password
        case UpdateUserAction.password:
          if (_authClient.currentUser == null) {
            throw const ServerException(
                message: 'User Does not exist', statusCode: 500);
          }
          final newData = jsonDecode(userdata as String) as DataMap;
          await _authClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );
          await _authClient.currentUser
              ?.updatePassword(newData['newPassword'] as String);

        case UpdateUserAction.bio:
          await _updateUser({'bio': userdata as String});
        case UpdateUserAction.pass:
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ' Error Occured',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallBackEmail) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallBackEmail,
            points: 0,
            fullName: user.displayName ?? '',
          ).toMap(),
        );
  }

  Future<void> _updateUser(DataMap data) async {
    await _cloudStoreClient
        .collection('users')
        .doc(_authClient.currentUser?.uid)
        .update(data);
  }
}
