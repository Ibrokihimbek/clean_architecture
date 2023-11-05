import 'dart:developer';
import 'dart:io';

import 'package:clean_architecture/core/local_source/local_source.dart';
import 'package:clean_architecture/features/home/data/data_cource/home_remote_data_source.dart';
import 'package:clean_architecture/features/home/domain/repository/home_repository.dart';
import 'package:clean_architecture/features/home/domain/usecase/home_usecase.dart';
import 'package:clean_architecture/features/home/presentation/bloc/home_bloc.dart';
import 'package:clean_architecture/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:clean_architecture/router/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/connectivity/internet_connection_checker.dart';

final sl = GetIt.instance;
late Box<dynamic> _box;

Future<void> init() async {
  /// External
  await initHive();
  sl
    ..registerLazySingleton(
      () => Dio()
        ..options = BaseOptions(
          contentType: 'application/json',
          sendTimeout: const Duration(seconds: 30),
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        )
        ..interceptors.addAll(
          [
            LogInterceptor(
              requestBody: kDebugMode,
              responseBody: kDebugMode,
              logPrint: (object) =>
                  kDebugMode ? log('dio: ${object.toString()}') : null,
            ),
            chuck.getDioInterceptor(),
          ],
        ),
    )

    /// Core
    ..registerFactory<SplashBloc>(SplashBloc.new)
    ..registerSingleton<LocalSource>(LocalSource(_box))
    ..registerLazySingleton(
      () => InternetConnectionChecker.createInstance(
        checkInterval: const Duration(seconds: 3),
      ),
    );

  /// features
  homeFeature();
}

void homeFeature() {
  sl
    ..registerFactory(() => HomeBloc(currencyUsCase: sl()))

  /// UseCases
    ..registerLazySingleton<CurrencyUseCase>(
          () => CurrencyUseCase(
        sl(),
      ),
    )

  ///Data and Network
    ..registerLazySingleton<HomeRemoteDataSource>(
          () => HomeRemoteDataSourceImpl(
        sl(),
      ),
    )

  ///Repositories
    ..registerLazySingleton<HomeRepository>(
          () => HomeRepositoryImpl(
        remoteDataSource: sl(),
      ),
    );
}

Future<void> initHive() async {
  const boxName = 'clean_architecture_box';
  final Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  _box = await Hive.openBox<dynamic>(boxName);
}


class LogBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      print(change);
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      print('$bloc closed');
    }
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      print('$bloc created');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      print('${bloc.runtimeType} $event');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      print('${bloc.runtimeType} $error');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      print(transition);
    }
  }
}
