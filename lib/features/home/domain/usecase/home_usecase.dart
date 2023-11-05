import 'package:clean_architecture/core/either_dart/either.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/features/home/domain/entities/cureency_entity.dart';
import 'package:clean_architecture/features/home/domain/repository/home_repository.dart';

class CurrencyUseCase extends UseCase<List<CurrencyEntity>, CurrencyParams> {
  CurrencyUseCase(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, List<CurrencyEntity>>> call(CurrencyParams params) async {
    final List<CurrencyEntity> sortedList = [];
    final response = await repository.fetchCurrency();
    for (final item in response.right) {
      if (item.nbuCellPrice.isNotEmpty && item.nbuBuyPrice.isNotEmpty) {
        sortedList.add(item);
      }
    }
    return Right(sortedList);
  }
}

class CurrencyParams {}
