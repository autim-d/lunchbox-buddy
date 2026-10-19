import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/ticket_clipper.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/saved_recipes_notifier.dart';

/// Recipe card shaped like a tactile lunch ticket with perforated edges
/// Resilient against 200% text scaling and fully RTL/LTR compliant.
class RecipeCard extends ConsumerWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    this.reasonKey,
    this.reasonText,
    this.score,
    this.onTap,
    this.elevation = 4.0,
    this.isScrollable = false,
  });

  final Recipe recipe;
  final String? reasonKey;
  final String? reasonText;
  final double? score;
  final VoidCallback? onTap;
  final double elevation;
  final bool isScrollable;

  String _resolveReason(BuildContext context) {
    if (reasonText != null && reasonText!.isNotEmpty) {
      return reasonText!;
    }
    final l10n = context.l10n;
    return switch (reasonKey) {
      'reason_ingredients_on_hand' => l10n.reasonIngredientsOnHand,
      'reason_kid_favorite' => l10n.reasonKidFavorite,
      'reason_hidden_veggies' => l10n.reasonHiddenVeggies,
      'reason_lunchbox_friendly' => l10n.reasonLunchboxFriendly,
      'reason_quick_prep' => l10n.reasonQuickPrep,
      'reason_balanced_meal' => l10n.reasonBalancedMeal,
      _ => l10n.reasonBalancedMeal,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final savedIds =
        ref.watch(savedRecipeIdsProvider).asData?.value ?? const <String>{};
    final isSaved = savedIds.contains(recipe.id);

    final totalMinutes = recipe.prepMinutes + recipe.cookMinutes;
    final resolvedReason = _resolveReason(context);

    // Dynamic header height adapts to notch position while giving room
    const notchY = 88.0;

    Widget cardBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ticket Header Area
        Container(
          height: notchY,
          padding: EdgeInsetsDirectional.only(
            start: spacing.lg,
            end: spacing.md,
            top: spacing.sm,
            bottom: spacing.sm,
          ),
          color: colors.surfaceSubtle.withValues(alpha: 0.7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ticket badge & time pill
              Expanded(
                child: Wrap(
                  spacing: spacing.sm,
                  runSpacing: spacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Ticket Stamp Badge
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: spacing.sm,
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
                            Icons.confirmation_number_outlined,
                            size: 14.0,
                            color: colors.accent,
                          ),
                          SizedBox(width: spacing.xs),
                          Text(
                            l10n.ticketLabel,
                            style: typography.labelSmall.copyWith(
                              color: colors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Time badge
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: spacing.sm,
                        vertical: spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondaryContainer,
                        borderRadius: BorderRadius.circular(radii.full),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14.0,
                            color: colors.secondary,
                          ),
                          SizedBox(width: spacing.xs),
                          Text(
                            l10n.totalMinutesFormat(totalMinutes),
                            style: typography.labelSmall.copyWith(
                              color: colors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Favorite / Save Button
              Semantics(
                button: true,
                label: isSaved
                    ? l10n.unsaveRecipeTooltip
                    : l10n.saveRecipeTooltip,
                child: IconButton(
                  icon: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isSaved ? colors.accent : colors.textSecondary,
                  ),
                  tooltip: isSaved
                      ? l10n.unsaveRecipeTooltip
                      : l10n.saveRecipeTooltip,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref
                        .read(savedRecipeIdsProvider.notifier)
                        .toggleSave(recipe.id);
                  },
                ),
              ),
            ],
          ),
        ),

        // Perforated Dashed Line Divider
        CustomPaint(
          size: const Size(double.infinity, 2.0),
          painter: DashedSeparatorPainter(
            color: colors.border,
            dashWidth: 6.0,
            dashSpace: 4.0,
            strokeWidth: 1.5,
          ),
        ),

        // Ticket Main Body Area
        Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Recipe Title
              Text(
                recipe.title,
                style: typography.titleLarge.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: spacing.xs),

              // Description
              Text(
                recipe.description,
                style: typography.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: spacing.md),

              // One-line Reason Banner (Why this meal was picked)
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: colors.secondaryContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(radii.md),
                  border: Border.all(
                    color: colors.secondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 18.0,
                      color: colors.secondary,
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Text(
                        resolvedReason,
                        style: typography.labelMedium.copyWith(
                          color: colors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.md),

              // Tags row (Halal, Lunchbox, Mood tags)
              Wrap(
                spacing: spacing.xs,
                runSpacing: spacing.xs,
                children: [
                  _TagChip(
                    label: 'حلال 100%',
                    icon: Icons.verified_rounded,
                    color: colors.secondary,
                  ),
                  ...recipe.tags.take(3).map((tag) {
                    return _TagChip(
                      label: '#$tag',
                      color: colors.textSecondary,
                    );
                  }),
                  if (score != null)
                    _TagChip(
                      label: l10n.scoreLabel(score!.toStringAsFixed(1)),
                      icon: Icons.star_rounded,
                      color: colors.warning,
                    ),
                ],
              ),
              SizedBox(height: spacing.lg),

              // Action button: Recipe details / Cook mode
              SizedBox(
                width: double.infinity,
                height: AppTokens.touchTargets.min,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.surfaceSubtle,
                    foregroundColor: colors.textPrimary,
                    elevation: 0,
                    side: BorderSide(color: colors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radii.md),
                    ),
                  ),
                  icon: Icon(
                    Icons.menu_book_rounded,
                    size: 18.0,
                    color: colors.textPrimary,
                  ),
                  label: Text(
                    l10n.cardActionDetails,
                    style: typography.labelLarge.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isScrollable) {
      cardBody = SingleChildScrollView(child: cardBody);
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.card),
        boxShadow: [
          BoxShadow(
            color: colors.buttonShadow.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipPath(
        clipper: PerforatedTicketClipper(
          borderRadius: radii.card,
          notchRadius: 12.0,
          notchY: notchY,
        ),
        child: Material(
          color: colors.surface,
          child: InkWell(onTap: onTap, child: cardBody),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radii.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.0, color: color),
            SizedBox(width: spacing.xs),
          ],
          Text(
            label,
            style: typography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
