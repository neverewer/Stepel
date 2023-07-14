import 'package:equatable/equatable.dart';

abstract class HomePageState extends Equatable {}

class InitialHomePageState extends HomePageState {
  @override
  List<Object?> get props => [];
}

class LoadedHomePageState extends HomePageState {
  final int? steps;
  final int? calories;
  final double? distance;
  final int? stepsTarget;
  final int? cardioPoints;
  final int? dayCardioPointsTarget;

  LoadedHomePageState(
      {this.cardioPoints = 0,
      this.dayCardioPointsTarget = 0,
      this.stepsTarget = 0,
      this.steps = 0,
      this.calories = 0,
      this.distance = 0});

  @override
  List<Object?> get props => [steps, calories, distance, stepsTarget, cardioPoints, dayCardioPointsTarget];

  LoadedHomePageState copyWith(
      {int? steps, int? calories, double? distance, int? stepsTarget, int? cardioPoints, int? dayCardioPointsTarget}) {
    return LoadedHomePageState(
        steps: steps ?? this.steps,
        calories: calories ?? this.calories,
        distance: distance ?? this.distance,
        stepsTarget: stepsTarget ?? this.stepsTarget,
        cardioPoints: cardioPoints ?? this.cardioPoints,
        dayCardioPointsTarget: dayCardioPointsTarget ?? this.dayCardioPointsTarget);
  }
}
