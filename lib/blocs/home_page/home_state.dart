import 'package:meta/meta.dart';

import '../../models/fit_data.dart';

/// {@template home_page_state_placeholder}
/// Entity placeholder for HomePageState
/// {@endtemplate}
typedef HomePageEntity = Object;

/// {@template home_page_state}
/// HomePageState.
/// {@endtemplate}
sealed class HomeState extends _$HomeStateBase {
  /// Idling state
  /// {@macro home_page_state}
  const factory HomeState.idle({
    String message,
  }) = HomeState$Idle;

  /// Processing
  /// {@macro home_page_state}
  const factory HomeState.processing({
    String message,
  }) = HomeState$Processing;

  /// Successful
  /// {@macro home_page_state}
  const factory HomeState.successful({
    required FitData fitData,
    final int dayCardioPointsTarget,
    final int stepTarget,
    final List<List<double>> weeklyData,
    String message,
  }) = HomeState$Successful;

  /// An error has occurred
  /// {@macro home_page_state}
  const factory HomeState.error({
    String message,
  }) = HomeState$Error;

  /// {@macro home_page_state}
  const HomeState({required super.message});
}

/// Idling state
/// {@nodoc}
final class HomeState$Idle extends HomeState with _$HomePageState {
  /// {@nodoc}
  const HomeState$Idle({super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class HomeState$Processing extends HomeState with _$HomePageState {
  /// {@nodoc}
  const HomeState$Processing({super.message = 'Processing'});
}

/// Successful
/// {@nodoc}
final class HomeState$Successful extends HomeState with _$HomePageState {
  final FitData fitData;
  final int dayCardioPointsTarget;
  final int stepTarget;
  final List<List<double>> weeklyData;

  const HomeState$Successful(
      {required this.fitData,
      this.dayCardioPointsTarget = 0,
      this.stepTarget = 0,
      this.weeklyData = const [],
      super.message = 'Successful'});

  HomeState$Successful copyWith({
    FitData? fitData,
    int? dayCardioPointsTarget,
    int? stepTarget,
    List<List<double>>? weeklyData,
  }) {
    return HomeState$Successful(
      fitData: fitData ?? this.fitData,
      dayCardioPointsTarget: dayCardioPointsTarget ?? this.dayCardioPointsTarget,
      stepTarget: stepTarget ?? this.stepTarget,
      weeklyData: weeklyData ?? this.weeklyData,
    );
  }
}

/// Error
/// {@nodoc}
final class HomeState$Error extends HomeState with _$HomePageState {
  /// {@nodoc}
  const HomeState$Error({super.message = 'An error has occurred.'});
}

/// {@nodoc}
base mixin _$HomePageState on HomeState {}

/// Pattern matching for [HomeState].
typedef HomePageStateMatch<R, S extends HomeState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$HomeStateBase {
  /// {@nodoc}
  const _$HomeStateBase({required this.message});

  /// Message or state description.
  @nonVirtual
  final String message;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [HomeState].
  R map<R>({
    required HomePageStateMatch<R, HomeState$Idle> idle,
    required HomePageStateMatch<R, HomeState$Processing> processing,
    required HomePageStateMatch<R, HomeState$Successful> successful,
    required HomePageStateMatch<R, HomeState$Error> error,
  }) =>
      switch (this) {
        HomeState$Idle s => idle(s),
        HomeState$Processing s => processing(s),
        HomeState$Successful s => successful(s),
        HomeState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [HomeState].
  R maybeMap<R>({
    HomePageStateMatch<R, HomeState$Idle>? idle,
    HomePageStateMatch<R, HomeState$Processing>? processing,
    HomePageStateMatch<R, HomeState$Successful>? successful,
    HomePageStateMatch<R, HomeState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [HomeState].
  R? mapOrNull<R>({
    HomePageStateMatch<R, HomeState$Idle>? idle,
    HomePageStateMatch<R, HomeState$Processing>? processing,
    HomePageStateMatch<R, HomeState$Successful>? successful,
    HomePageStateMatch<R, HomeState$Error>? error,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
        successful: successful ?? (_) => null,
        error: error ?? (_) => null,
      );

  @override
  int get hashCode => message.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);
}
