import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

/// Finish screen with cheerful celebration animation when the recipe is cooked
class CookCelebrationView extends StatelessWidget {
  const CookCelebrationView({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget badgeContent = Container(
      width: 120.0,
      height: 120.0,
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        shape: BoxShape.circle,
        border: Border.all(color: colors.secondary, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(Icons.verified_rounded, size: 64.0, color: colors.secondary),
    );

    if (!reduceMotion) {
      badgeContent = badgeContent
          .animate()
          .scale(
            begin: const Offset(0.3, 0.3),
            end: const Offset(1.0, 1.0),
            duration: 400.ms,
            curve: Curves.elasticOut,
          )
          .fadeIn(duration: 250.ms);
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.all(spacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                badgeContent,
                SizedBox(height: spacing.xl),

                // Celebration Title
                Text(
                  l10n.celebrationTitle,
                  style: typography.displayMedium.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.sm),

                // Subtitle
                Text(
                  l10n.celebrationSubtitle,
                  style: typography.bodyLarge.copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.lg),

                // Recipe Card Summary
                Container(
                  padding: EdgeInsetsDirectional.all(spacing.lg),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(radii.card),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.all(spacing.sm),
                        decoration: BoxDecoration(
                          color: colors.accentContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lunch_dining_rounded,
                          size: 24.0,
                          color: colors.accent,
                        ),
                      ),
                      SizedBox(width: spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.title,
                              style: typography.titleSmall.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${recipe.servings} حصة • ${recipe.prepMinutes + recipe.cookMinutes} دقيقة',
                              style: typography.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.xxl),

                // Back to Home Button
                AppButton(
                  label: l10n.backToHome,
                  icon: Icons.home_rounded,
                  onPressed: () {
                    context.go('/home');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
