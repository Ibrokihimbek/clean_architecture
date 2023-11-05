import 'package:clean_architecture/core/utils/utils.dart';
import 'package:clean_architecture/features/home/domain/entities/cureency_entity.dart';
import 'package:flutter/material.dart';

class CurrencyWidget extends StatelessWidget {
  const CurrencyWidget({super.key, required this.currency});

  final CurrencyEntity currency;

  @override
  Widget build(BuildContext context) => Padding(
        padding: AppUtils.kPaddingAll16,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: AppUtils.kBorderRadius12,
          ),
          child: Padding(
            padding: AppUtils.kPaddingAll12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppUtils.kGap16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 30,
                          child: Image.network(
                            'https://flagcdn.com/w320/${currency.code.toString().toLowerCase().substring(0, 2)}.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        AppUtils.kGap12,
                        Text(
                          currency.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.notifications_active_outlined,
                        size: 25,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                AppUtils.kGap16,
                Text(
                  currency.date.substring(0, 10),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              AppUtils.kGap16,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Narx',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Sotib olish',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Sotish',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currency.cbPrice,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      currency.nbuBuyPrice,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      currency.nbuCellPrice,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
