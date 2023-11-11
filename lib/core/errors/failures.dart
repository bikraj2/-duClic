import 'package:equatable/equatable.dart';
import 'package:sikshya/core/errors/exceptions.dart';

// an interface all the failures that may occur
// failure could be due to apis or cache
abstract class Failure extends Equatable {
  Failure({required this.message, required this.statusCode})
      : assert(
          statusCode.runtimeType == int || statusCode.runtimeType == String,
          'StatusCode cannot be a ${statusCode.runtimeType}',
        );
  final String message;
  final dynamic statusCode;
  @override
  List<Object?> get props => [message, statusCode];

  String get errorMessage =>
      "$statusCode: ${statusCode is String ? ' ' : 'Error: $message'}";
}

class ApiFailure extends Failure {
   ApiFailure({
    required super.message,
    required super.statusCode,
  });
  ApiFailure.fromException(ServerException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, required super.statusCode});
}
