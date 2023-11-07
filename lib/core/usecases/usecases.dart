import 'package:sikshya/core/utils/typedefs.dart';

abstract class UseCase {}

abstract class UseCaseWithParams<Type, Params> {
  const UseCaseWithParams();

  ResultFuture<Type> call(Params params);

}

abstract class UseCaseWithOutParams<Type > {
  const UseCaseWithOutParams();

  ResultFuture<Type> call( );
}
