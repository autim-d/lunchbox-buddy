import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/core/utils/duration_parser.dart';
import 'package:lunchbox_buddy/features/cook/presentation/cook_timer_notifier.dart';

/// Tactile, high-contrast TimerPill designed for easy glance and big-finger taps
/// from kitchen counters (min height 56dp).
class TimerPill extends StatelessWidget {
  const TimerPill({
    super.key,
    required this.timer,
    required this.onStart,
    required this.onPause,
    required this.onReset,
  });

  final CookTimer timer;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final isRunning = timer.isRunning;
    final isCompleted = timer.isCompleted;

    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final Color accentColor;

    if (isCompleted) {
      bgColor = colors.errorContainer;
      borderColor = colors.error;
      textColor = colors.error;
      accentColor = colors.error;
    } else if (isRunning) {
      bgColor = colors.secondaryContainer;
      borderColor = colors.secondary;
      textColor = colors.secondary;
      accentColor = colors.secondary;
    } else {
      bgColor = colors.surfaceSubtle;
      borderColor = colors.border;
      textColor = colors.textPrimary;
      accentColor = colors.accent;
    }

    final digitalTime = DurationParser.formatDigital(timer.remaining);

    return Semantics(
      container: true,
      label: '${timer.label}: $digitalTime',
      child: AnimatedContainer(
        duration: AppTokens.durations.standard,
        curve: AppTokens.curves.easeOut,
        padding: EdgeInsetsDirectional.all(spacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radii.card),
          border: Border.all(color: borderColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: colors.buttonShadow.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Bar: Label + Digital Countdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Timer Label
                Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.notifications_active_rounded
                          : (isRunning
                                ? Icons.hourglass_top_rounded
                                : Icons.timer_outlined),
                      size: 22.0,
                      color: accentColor,
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      isCompleted ? l10n.timerFinished : timer.label,
                      style: typography.titleSmall.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Digital Countdown (Large Western digits)
                Text(
                  digitalTime,
                  style: typography.displayMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.sm),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(radii.full),
              child: LinearProgressIndicator(
                value: timer.progress,
                minHeight: 6.0,
                backgroundColor: colors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
            SizedBox(height: spacing.md),

            // Tactile Action Buttons Row (big 56dp greasy-finger friendly tap targets)
            Row(
              children: [
                // Primary Start / Pause Button
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: AppTokens.touchTargets.primaryAction,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRunning
                            ? colors.warningContainer
                            : (isCompleted ? colors.error : colors.secondary),
                        foregroundColor: isRunning
                            ? colors.warning
                            : colors.onSecondary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radii.md),
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (isRunning) {
                          onPause();
                        } else {
                          onStart();
                        }
                      },
                      icon: Icon(
                        isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 26.0,
                      ),
                      label: Text(
                        isRunning
                            ? l10n.pauseTimer
                            : (timer.progress > 0 && !isCompleted
                                  ? l10n.resumeTimer
                                  : l10n.startTimer),
                        style: typography.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing.sm),

                // Reset Button
                SizedBox(
                  height: AppTokens.touchTargets.primaryAction,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textSecondary,
                      side: BorderSide(color: colors.border, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radii.md),
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onReset();
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 22.0),
                    label: Text(
                      l10n.resetTimer,
                      style: typography.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
