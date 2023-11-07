import 'package:sikshya/core/common/enums/update_user.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/auth/domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();
 
  ResultFuture<void> forgotPassword(String email);

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });
  ResultFuture<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}
