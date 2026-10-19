import 'package:flutter/material.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/timer_pill.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/cook/presentation/cook_timer_notifier.dart';

/// Single page in Cook Mode PageView featuring 24sp+ high-contrast step instructions
/// and integrated TimerPills.
class StepPage extends StatelessWidget {
  const StepPage({
    super.key,
    required this.stepIndex,
    required this.totalSteps,
    required this.stepText,
    required this.timers,
    required this.onStartTimer,
    required this.onPauseTimer,
    required this.onResetTimer,
  });

  final int stepIndex;
  final int totalSteps;
  final String stepText;
  final List<CookTimer> timers;
  final ValueChanged<String> onStartTimer;
  final ValueChanged<String> onPauseTimer;
  final ValueChanged<String> onResetTimer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step Counter Badge
          Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.accentContainer,
                  borderRadius: BorderRadius.circular(radii.full),
                  border: Border.all(
                    color: colors.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.checklist_rtl_rounded,
                      size: 18.0,
                      color: colors.accent,
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      l10n.stepProgressLabel(stepIndex + 1, totalSteps),
                      style: typography.labelMedium.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),

          // Main Step Card with 24sp+ High-Contrast Text
          Container(
            padding: EdgeInsetsDirectional.all(spacing.xl),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(radii.card),
              border: Border.all(color: colors.borderSubtle),
              boxShadow: [
                BoxShadow(
                  color: colors.buttonShadow.withValues(alpha: 0.04),
                  offset: const Offset(0, 4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Text(
              stepText,
              style: typography.cookModeStep.copyWith(
                color: colors.textPrimary,
                height: 1.45,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: spacing.lg),

          // Step Timers (if duration detected)
          if (timers.isNotEmpty) ...[
            ...timers.map((timer) {
              return Padding(
                padding: EdgeInsetsDirectional.only(bottom: spacing.md),
                child: TimerPill(
                  timer: timer,
                  onStart: () => onStartTimer(timer.id),
                  onPause: () => onPauseTimer(timer.id),
                  onReset: () => onResetTimer(timer.id),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
