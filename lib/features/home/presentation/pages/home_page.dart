import 'package:clean_architecture/core/widgets/loading/modal_progress_hud.dart';
import 'package:clean_architecture/features/home/presentation/bloc/home_bloc.dart';
import 'package:clean_architecture/features/home/presentation/widgets/currency_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Currency App'),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) => ModalProgressHUD(
            inAsyncCall: state.status.isLoading,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => CurrencyWidget(
                        currency: state.currencyList[index],
                      ),
                      childCount: state.currencyList.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
