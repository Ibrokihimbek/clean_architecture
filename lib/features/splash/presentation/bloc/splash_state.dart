part of 'splash_bloc.dart';

class SplashState extends Equatable {
  const SplashState({this.isTimerFinished = false});

  final bool isTimerFinished;

  @override
  List<Object?> get props => [isTimerFinished];
}
