import 'package:flutter/material.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

/// Small, warm AI badge displayed on AI-ranked or adapted recipe results.
class AiBadge extends StatelessWidget {
  const AiBadge({
    super.key,
    this.label = 'اقتراح ذكي',
    this.isCompact = false,
  });

  final String label;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: isCompact ? spacing.xs : spacing.sm,
        vertical: isCompact ? 2.0 : spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.secondaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(radii.full),
        border: Border.all(
          color: colors.secondary.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: isCompact ? 11.0 : 13.0,
            color: colors.secondary,
          ),
          SizedBox(width: isCompact ? 3.0 : spacing.xs),
          Text(
            label,
            style: typography.labelSmall.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.bold,
              fontSize: isCompact ? 10.0 : 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
