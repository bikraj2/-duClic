import 'package:equatable/equatable.dart';
import 'package:sikshya/core/usecases/usecases.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/auth/domain/repos/auth_repo.dart';

class SignUp extends UseCaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);
  final AuthRepo _repo;
  @override
  ResultFuture<void> call(SignUpParams params) async => _repo.signUp(
        email: params.email,
        password: params.password,
        fullName: params.fullName,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams(
      {required this.email, required this.fullName, required this.password});

  final String email;
  final String fullName;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
