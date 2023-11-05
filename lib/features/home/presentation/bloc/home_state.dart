part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = CurrencyStatus.initial,
    this.currencyList = const [],
  });

  final CurrencyStatus status;
  final List<CurrencyEntity> currencyList;

  HomeState copyWith({
    CurrencyStatus? status,
    List<CurrencyEntity>? currencyList,
    String? errorText,
  }) => HomeState(
      status: status ?? this.status,
      currencyList: currencyList ?? this.currencyList,
    );

  @override
  List<Object> get props => [
    status,
    currencyList,
  ];
}

enum CurrencyStatus { initial, success, error, loading }

extension CurrencyStatusX on CurrencyStatus {
  bool get isInitial => this == CurrencyStatus.initial;

  bool get isSuccess => this == CurrencyStatus.success;

  bool get isError => this == CurrencyStatus.error;

  bool get isLoading => this == CurrencyStatus.loading;
}
