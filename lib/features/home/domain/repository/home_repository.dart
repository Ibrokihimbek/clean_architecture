import 'package:clean_architecture/core/either_dart/either.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/features/home/data/data_cource/home_remote_data_source.dart';
import 'package:clean_architecture/features/home/domain/entities/cureency_entity.dart';

part 'package:clean_architecture/features/home/data/repository/home_repository_impl.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CurrencyEntity>>> fetchCurrency();
}