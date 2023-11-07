import 'package:equatable/equatable.dart';
import 'package:sikshya/core/usecases/usecases.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/auth/domain/repos/auth_repo.dart';

class ForgetPassword extends UseCaseWithParams<void, ForgotPasswordParams> {
  const ForgetPassword(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<void> call(ForgotPasswordParams params) =>
      _repo.forgotPassword(params.email);
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({required this.email});

  final String email;
  @override
  List<Object?> get props => [email];
}
