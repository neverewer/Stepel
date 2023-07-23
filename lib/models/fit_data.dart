import 'package:meta/meta.dart';

@immutable
final class FitData implements Comparable<FitData> {
  FitData(this.steps);

  static FitData zero = FitData(0);

  final int steps;

  late final double calories = steps * 0.04;

  late final int cardioPoints = steps ~/ 200;

  late final double moveDistance = steps * 0.0007;

  late final int moveMinutes = steps ~/ 100;

  FitData copyWith({
    int? newSteps,
  }) =>
      FitData(
        newSteps ?? steps,
      );

  @override
  int compareTo(FitData other) => steps.compareTo(other.steps);

  @override
  bool operator ==(Object other) => identical(this, other) || other is FitData && other.steps == steps;

  @override
  int get hashCode => steps;
}
