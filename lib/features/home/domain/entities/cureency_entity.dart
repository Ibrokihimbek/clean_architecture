import 'package:equatable/equatable.dart';

class CurrencyEntity extends Equatable {
  const CurrencyEntity({
    required this.title,
    required this.code,
    required this.cbPrice,
    required this.nbuBuyPrice,
    required this.nbuCellPrice,
    required this.date,
  });

  final String title;
  final String code;
  final String cbPrice;
  final String nbuBuyPrice;
  final String nbuCellPrice;
  final String date;

  @override
  List<Object?> get props => [
        title,
        code,
        cbPrice,
        nbuBuyPrice,
        nbuCellPrice,
        date,
      ];
}
