part of 'package:clean_architecture/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  HomeRepositoryImpl({
    required this.remoteDataSource,
  });

  final HomeRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<CurrencyEntity>>> fetchCurrency() async {
    try {
      final response = await remoteDataSource.fetchCurrency();
      return Right(
        response.map((e) => e.toEntity()).toList(),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
