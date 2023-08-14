import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// {@template profile_state_placeholder}
/// Entity placeholder for ProfileState
/// {@endtemplate}
typedef ProfileEntity = Object;

/// {@template profile_state}
/// ProfileState.
/// {@endtemplate}
sealed class ProfileState extends _$ProfileStateBase {
  /// Idling state
  /// {@macro profile_state}
  const factory ProfileState.idle({
    String message,
  }) = ProfileState$Idle;

  /// Processing
  /// {@macro profile_state}
  const factory ProfileState.processing({
    String message,
  }) = ProfileState$Processing;

  /// Successful
  /// {@macro profile_state}
  const factory ProfileState.successful({
    int stepsTarget,
    int cardioPointsTarget,
    bool isSleepingModeActive,
    TimeOfDay wakeUpTime,
    TimeOfDay timeToSleep,
    String message,
  }) = ProfileState$Successful;

  /// An error has occurred
  /// {@macro profile_state}
  const factory ProfileState.error({
    String message,
  }) = ProfileState$Error;

  /// {@macro profile_state}
  const ProfileState({required super.message});
}

/// Idling state
/// {@nodoc}
final class ProfileState$Idle extends ProfileState with _$ProfileState {
  /// {@nodoc}
  const ProfileState$Idle({super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class ProfileState$Processing extends ProfileState with _$ProfileState {
  /// {@nodoc}
  const ProfileState$Processing({super.message = 'Processing'});
}

/// Successful
/// {@nodoc}
final class ProfileState$Successful extends ProfileState with _$ProfileState {
  final int stepsTarget;
  final int cardioPointsTarget;
  final bool isSleepingModeActive;
  final TimeOfDay wakeUpTime;
  final TimeOfDay timeToSleep;

  /// {@nodoc}
  const ProfileState$Successful(
      {this.stepsTarget = 0,
      this.cardioPointsTarget = 0,
      this.isSleepingModeActive = false,
      this.wakeUpTime = const TimeOfDay(hour: 7, minute: 0),
      this.timeToSleep = const TimeOfDay(hour: 23, minute: 0),
      super.message = 'Successful'});

  ProfileState$Successful copyWith({
    int? stepsTarget,
    int? cardioPointsTarget,
    bool? isSleepingModeActive,
    TimeOfDay? wakeUpTime,
    TimeOfDay? timeToSleep,
  }) {
    return ProfileState$Successful(
      stepsTarget: stepsTarget ?? this.stepsTarget,
      cardioPointsTarget: cardioPointsTarget ?? this.cardioPointsTarget,
      isSleepingModeActive: isSleepingModeActive ?? this.isSleepingModeActive,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      timeToSleep: timeToSleep ?? this.timeToSleep,
    );
  }
}

/// Error
/// {@nodoc}
final class ProfileState$Error extends ProfileState with _$ProfileState {
  /// {@nodoc}
  const ProfileState$Error({super.message = 'An error has occurred.'});
}

/// {@nodoc}
base mixin _$ProfileState on ProfileState {}

/// Pattern matching for [ProfileState].
typedef ProfileStateMatch<R, S extends ProfileState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$ProfileStateBase {
  /// {@nodoc}
  const _$ProfileStateBase({required this.message});

  /// Message or state description.
  @nonVirtual
  final String message;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [ProfileState].
  R map<R>({
    required ProfileStateMatch<R, ProfileState$Idle> idle,
    required ProfileStateMatch<R, ProfileState$Processing> processing,
    required ProfileStateMatch<R, ProfileState$Successful> successful,
    required ProfileStateMatch<R, ProfileState$Error> error,
  }) =>
      switch (this) {
        ProfileState$Idle s => idle(s),
        ProfileState$Processing s => processing(s),
        ProfileState$Successful s => successful(s),
        ProfileState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [ProfileState].
  R maybeMap<R>({
    ProfileStateMatch<R, ProfileState$Idle>? idle,
    ProfileStateMatch<R, ProfileState$Processing>? processing,
    ProfileStateMatch<R, ProfileState$Successful>? successful,
    ProfileStateMatch<R, ProfileState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [ProfileState].
  R? mapOrNull<R>({
    ProfileStateMatch<R, ProfileState$Idle>? idle,
    ProfileStateMatch<R, ProfileState$Processing>? processing,
    ProfileStateMatch<R, ProfileState$Successful>? successful,
    ProfileStateMatch<R, ProfileState$Error>? error,
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
