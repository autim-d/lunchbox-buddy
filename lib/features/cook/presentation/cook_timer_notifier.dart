import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/utils/duration_parser.dart';

/// Immutable model representing an active cooking step timer
class CookTimer {
  const CookTimer({
    required this.id,
    required this.stepIndex,
    required this.duration,
    required this.remaining,
    required this.label,
    this.isRunning = false,
    this.isCompleted = false,
  });

  final String id;
  final int stepIndex;
  final Duration duration;
  final Duration remaining;
  final String label;
  final bool isRunning;
  final bool isCompleted;

  double get progress {
    if (duration.inSeconds <= 0) return 1.0;
    final elapsed = duration.inSeconds - remaining.inSeconds;
    return (elapsed / duration.inSeconds).clamp(0.0, 1.0);
  }

  CookTimer copyWith({
    Duration? remaining,
    bool? isRunning,
    bool? isCompleted,
  }) {
    return CookTimer(
      id: id,
      stepIndex: stepIndex,
      duration: duration,
      remaining: remaining ?? this.remaining,
      label: label,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Notifier managing all step timers for a recipe during Cook Mode.
/// Timers run continuously in the background across step navigation.
class CookTimersNotifier extends Notifier<Map<String, CookTimer>> {
  Timer? _ticker;

  @override
  Map<String, CookTimer> build() {
    ref.onDispose(() {
      _ticker?.cancel();
      _ticker = null;
    });
    return const {};
  }

  /// Initializes timers for recipe steps by detecting durations in step text.
  void initSteps(List<String> steps, {bool force = false}) {
    if (!force && state.isNotEmpty) return; // already initialized

    final initialTimers = <String, CookTimer>{};
    for (var i = 0; i < steps.length; i++) {
      final parsed = DurationParser.parseAll(steps[i]);
      for (var j = 0; j < parsed.length; j++) {
        final item = parsed[j];
        final id = 'step_${i}_timer_$j';
        initialTimers[id] = CookTimer(
          id: id,
          stepIndex: i,
          duration: item.duration,
          remaining: item.duration,
          label: item.label,
        );
      }
    }
    state = initialTimers;
  }

  void resetAll() {
    _ticker?.cancel();
    _ticker = null;
    state = const {};
  }

  void startTimer(String timerId) {
    final timer = state[timerId];
    if (timer == null || timer.isRunning) return;

    // Reset if it was already completed
    final updatedTimer = timer.isCompleted
        ? timer.copyWith(
            remaining: timer.duration,
            isRunning: true,
            isCompleted: false,
          )
        : timer.copyWith(isRunning: true, isCompleted: false);

    state = {...state, timerId: updatedTimer};
    _ensureTicker();
  }

  void pauseTimer(String timerId) {
    final timer = state[timerId];
    if (timer == null || !timer.isRunning) return;

    state = {...state, timerId: timer.copyWith(isRunning: false)};
    _checkTicker();
  }

  void resetTimer(String timerId) {
    final timer = state[timerId];
    if (timer == null) return;

    state = {
      ...state,
      timerId: timer.copyWith(
        remaining: timer.duration,
        isRunning: false,
        isCompleted: false,
      ),
    };
    _checkTicker();
  }

  void _ensureTicker() {
    if (_ticker != null && _ticker!.isActive) return;

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _checkTicker() {
    final hasRunning = state.values.any((t) => t.isRunning);
    if (!hasRunning) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  void _tick() {
    var anyCompleted = false;
    final updated = <String, CookTimer>{};

    for (final entry in state.entries) {
      final timer = entry.value;
      if (!timer.isRunning) {
        updated[entry.key] = timer;
        continue;
      }

      final nextSec = timer.remaining.inSeconds - 1;
      if (nextSec <= 0) {
        updated[entry.key] = timer.copyWith(
          remaining: Duration.zero,
          isRunning: false,
          isCompleted: true,
        );
        anyCompleted = true;
      } else {
        updated[entry.key] = timer.copyWith(
          remaining: Duration(seconds: nextSec),
        );
      }
    }

    state = updated;

    if (anyCompleted) {
      _triggerCompletionFeedback();
    }

    _checkTicker();
  }

  void _triggerCompletionFeedback() {
    try {
      SystemSound.play(SystemSoundType.alert);
    } catch (_) {}

    try {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 200), () {
        HapticFeedback.heavyImpact();
      });
    } catch (_) {}
  }
}

/// Provider for CookTimersNotifier
final cookTimersNotifierProvider =
    NotifierProvider<CookTimersNotifier, Map<String, CookTimer>>(
      CookTimersNotifier.new,
    );

/// Provider for the state of a specific timer
final cookTimerStateProvider = Provider.autoDispose.family<CookTimer?, String>((
  ref,
  timerId,
) {
  final timers = ref.watch(cookTimersNotifierProvider);
  return timers[timerId];
});
