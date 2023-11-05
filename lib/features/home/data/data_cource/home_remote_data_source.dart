import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/home/data/models/currency_response_model.dart';
import 'package:dio/dio.dart';

part 'package:clean_architecture/features/home/data/data_cource/home_remote_data_source_impl.dart';

abstract class HomeRemoteDataSource {
  const HomeRemoteDataSource();

  Future<List<CurrencyResponseModel>> fetchCurrency();
}