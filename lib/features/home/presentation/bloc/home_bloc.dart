import 'package:clean_architecture/features/home/domain/entities/cureency_entity.dart';
import 'package:clean_architecture/features/home/domain/usecase/home_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.currencyUsCase}) : super(const HomeState()) {
    on<FetchCurrencyEvent>(_currencyGetData);
  }

  final CurrencyUseCase currencyUsCase;

  Future<void> _currencyGetData(
      FetchCurrencyEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: CurrencyStatus.loading));
    final result = await currencyUsCase(
      CurrencyParams(),
    );
    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: CurrencyStatus.error,
          ),
        );
      },
      (result) {
        emit(
          state.copyWith(
            currencyList: result,
            status: CurrencyStatus.success,
          ),
        );
      },
    );
  }
}
