import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState()) {
    on<SplashEvent>(_splashHandler);
  }

  Future<void> _splashHandler(
    SplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2)).then(
      (value) => emit(
        const SplashState(isTimerFinished: true),
      ),
    );
  }
}
