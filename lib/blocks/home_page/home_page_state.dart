import 'package:equatable/equatable.dart';
import 'package:stepel/models/fit_data.dart';

abstract class HomePageState extends Equatable {}

class InitialHomePageState extends HomePageState {
  @override
  List<Object?> get props => [];
}

class LoadedHomePageState extends HomePageState {
  final FitData fitData;
  final int dayCardioPointsTarget;
  final int stepTarget;

  LoadedHomePageState({
    required this.fitData,
    this.dayCardioPointsTarget = 0,
    this.stepTarget = 0,
  });

  @override
  List<Object?> get props => [fitData, dayCardioPointsTarget, stepTarget];

  LoadedHomePageState copyWith({
    FitData? fitData,
    int? dayCardioPointsTarget,
    int? stepTarget,
  }) {
    return LoadedHomePageState(
      fitData: fitData ?? this.fitData,
      dayCardioPointsTarget: dayCardioPointsTarget ?? this.dayCardioPointsTarget,
      stepTarget: stepTarget ?? this.stepTarget,
    );
  }
}
