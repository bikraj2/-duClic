import 'package:equatable/equatable.dart';
import 'package:sikshya/core/common/enums/update_user.dart';
import 'package:sikshya/core/usecases/usecases.dart';
import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/auth/domain/repos/auth_repo.dart';

class UpdateUser extends UseCaseWithParams<void, UpdateUserParams> {
  const UpdateUser(this._repo);
  final AuthRepo _repo;
  @override
  ResultFuture<void> call(UpdateUserParams params) =>
      _repo.updateUser(action: params.action, userData: params.userData);
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.userData, required this.action});
  const UpdateUserParams.empty()
      : this(action: UpdateUserAction.pass, userData: 'userData');
  final dynamic userData;
  final UpdateUserAction action;
  @override
  List<Object?> get props => [userData, action];
}
