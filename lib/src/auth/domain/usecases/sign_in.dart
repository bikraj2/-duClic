import 'package:equatable/equatable.dart';
import 'package:sikshya/core/usecases/usecases.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/auth/domain/entities/user.dart';
import 'package:sikshya/src/auth/domain/repos/auth_repo.dart';

class SignIn extends UseCaseWithParams<void, SignInParams> {
  const SignIn(this._repo);
  final AuthRepo _repo;
  @override
  ResultFuture<LocalUser> call(SignInParams params) =>
      _repo.signIn(email: params.email, password: params.password);
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  final String password;
  final String email;

  @override
  List<Object?> get props => [email, password];
}
