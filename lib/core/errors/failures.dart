library;

/// Core error types and Result wrapper for structured operation results.
/// Pure Dart, no Flutter imports.

/// Base class for all failure results in Lunchbox Buddy
sealed class Failure {
  const Failure(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// Network connectivity or transport failure (offline, DNS, socket drop)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.cause]);
}

/// AI model timeout failure
class AiTimeoutFailure extends Failure {
  const AiTimeoutFailure(super.message, [super.cause]);
}

/// AI JSON response validation or schema mismatch failure
class AiSchemaFailure extends Failure {
  const AiSchemaFailure(super.message, [super.cause]);
}

/// Firebase App Check attestation failure
class AppCheckFailure extends Failure {
  const AppCheckFailure(super.message, [super.cause]);
}

/// Authentication or session failure
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.cause]);
}

/// Unexpected or unclassified failure
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.cause]);
}

/// Generic Result type representing either a [Success] with data or an [ErrorResult] with [Failure].
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ErrorResult<T>;

  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    ErrorResult() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success() => null,
    ErrorResult(:final failure) => failure,
  };

  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) error,
  }) {
    return switch (this) {
      Success(:final value) => success(value),
      ErrorResult(:final failure) => error(failure),
    };
  }
}

/// Successful operation result containing [value]
class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Failed operation result containing [failure]
class ErrorResult<T> extends Result<T> {
  const ErrorResult(this.failure);
  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ErrorResult<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure);

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'ErrorResult($failure)';
}
