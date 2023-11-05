import 'package:clean_architecture/core/either_dart/either.dart';
import 'package:clean_architecture/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
