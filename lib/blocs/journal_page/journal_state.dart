import 'package:meta/meta.dart';

import '../../models/fit_data.dart';

/// {@template journal_state_placeholder}
/// Entity placeholder for JournalState
/// {@endtemplate}
typedef JournalEntity = List<FitData>;

/// {@template journal_state}
/// JournalState.
/// {@endtemplate}
sealed class JournalState extends _$JournalStateBase {
  /// Idling state
  /// {@macro journal_state}
  const factory JournalState.idle({
    required JournalEntity? data,
    String message,
  }) = JournalState$Idle;

  /// Processing
  /// {@macro journal_state}
  const factory JournalState.processing({
    required JournalEntity? data,
    String message,
  }) = JournalState$Processing;

  /// Successful
  /// {@macro journal_state}
  const factory JournalState.successful({
    required JournalEntity? data,
    String message,
  }) = JournalState$Successful;

  /// An error has occurred
  /// {@macro journal_state}
  const factory JournalState.error({
    required JournalEntity? data,
    String message,
  }) = JournalState$Error;

  /// {@macro journal_state}
  const JournalState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class JournalState$Idle extends JournalState with _$JournalState {
  /// {@nodoc}
  const JournalState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class JournalState$Processing extends JournalState with _$JournalState {
  /// {@nodoc}
  const JournalState$Processing({required super.data, super.message = 'Processing'});
}

/// Successful
/// {@nodoc}
final class JournalState$Successful extends JournalState with _$JournalState {
  /// {@nodoc}
  const JournalState$Successful({required super.data, super.message = 'Successful'});
}

/// Error
/// {@nodoc}
final class JournalState$Error extends JournalState with _$JournalState {
  /// {@nodoc}
  const JournalState$Error({required super.data, super.message = 'An error has occurred.'});
}

/// {@nodoc}
base mixin _$JournalState on JournalState {}

/// Pattern matching for [JournalState].
typedef JournalStateMatch<R, S extends JournalState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$JournalStateBase {
  /// {@nodoc}
  const _$JournalStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final JournalEntity? data;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Has data?
  bool get hasData => data != null;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [JournalState].
  R map<R>({
    required JournalStateMatch<R, JournalState$Idle> idle,
    required JournalStateMatch<R, JournalState$Processing> processing,
    required JournalStateMatch<R, JournalState$Successful> successful,
    required JournalStateMatch<R, JournalState$Error> error,
  }) =>
      switch (this) {
        JournalState$Idle s => idle(s),
        JournalState$Processing s => processing(s),
        JournalState$Successful s => successful(s),
        JournalState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [JournalState].
  R maybeMap<R>({
    JournalStateMatch<R, JournalState$Idle>? idle,
    JournalStateMatch<R, JournalState$Processing>? processing,
    JournalStateMatch<R, JournalState$Successful>? successful,
    JournalStateMatch<R, JournalState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [JournalState].
  R? mapOrNull<R>({
    JournalStateMatch<R, JournalState$Idle>? idle,
    JournalStateMatch<R, JournalState$Processing>? processing,
    JournalStateMatch<R, JournalState$Successful>? successful,
    JournalStateMatch<R, JournalState$Error>? error,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
        successful: successful ?? (_) => null,
        error: error ?? (_) => null,
      );

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);
}
