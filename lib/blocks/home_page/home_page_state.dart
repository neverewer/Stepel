import 'package:equatable/equatable.dart';

abstract class HomePageState extends Equatable {}

class InitialHomePageState extends HomePageState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadedHomePageState extends HomePageState {
  final int? steps;
  final int? calories;
  final double? distance;
  final int? stepsTarget;

  LoadedHomePageState({this.stepsTarget, this.steps, this.calories, this.distance});

  @override
  List<Object?> get props => [steps, calories, distance];
}
