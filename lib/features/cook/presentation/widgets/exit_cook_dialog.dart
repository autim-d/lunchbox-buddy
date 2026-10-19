import 'package:flutter/material.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

/// Modal dialog prompting the user to confirm exiting Cook Mode.
class ExitCookConfirmationDialog extends StatelessWidget {
  const ExitCookConfirmationDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const ExitCookConfirmationDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radii.card),
      ),
      icon: Container(
        padding: EdgeInsetsDirectional.all(spacing.md),
        decoration: BoxDecoration(
          color: colors.warningContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.warning_amber_rounded,
          color: colors.warning,
          size: 32.0,
        ),
      ),
      title: Text(
        l10n.exitCookModeTitle,
        style: typography.titleMedium.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        l10n.exitCookModeMessage,
        style: typography.bodyMedium.copyWith(color: colors.textSecondary),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: EdgeInsetsDirectional.all(spacing.md),
      actions: [
        // Stay Button (Primary)
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: colors.secondary,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            l10n.stayInCookMode,
            style: typography.labelLarge.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Confirm Exit Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.textInverse,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radii.md),
            ),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            l10n.confirmExitCookMode,
            style: typography.labelLarge.copyWith(
              color: colors.textInverse,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
