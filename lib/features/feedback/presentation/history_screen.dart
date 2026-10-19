import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/kid_avatar_picker.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';

/// Screen listing past meals with reactions and reasons
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _formatFriendlyDate(BuildContext context, DateTime date) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final mealDate = DateTime(date.year, date.month, date.day);
    final diffDays = today.difference(mealDate).inDays;

    if (diffDays == 0) return l10n.today;
    if (diffDays == 1) return l10n.yesterday;
    if (diffDays < 7) return l10n.daysAgo(diffDays);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _resolveReason(
    BuildContext context,
    String? reasonTag,
    String? notes,
  ) {
    if (reasonTag == null) return '';
    final l10n = context.l10n;
    return switch (reasonTag) {
      'too_spicy' => l10n.reasonTooSpicy,
      'texture' => l10n.reasonTexture,
      'disliked_ingredient' =>
        notes != null && notes.isNotEmpty
            ? '${l10n.reasonDislikedIngredient} ($notes)'
            : l10n.reasonDislikedIngredient,
      'not_hungry' => l10n.reasonNotHungry,
      _ => reasonTag,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final feedbacksAsync = ref.watch(feedbackListNotifierProvider);
    final recipesAsync = ref.watch(allRecipesProvider);
    final kidsAsync = ref.watch(kidsListNotifierProvider);

    final recipesMap = {
      for (final r in recipesAsync.asData?.value ?? const <Recipe>[]) r.id: r,
    };
    final kidsMap = {
      for (final k in kidsAsync.asData?.value ?? const <KidProfile>[]) k.id: k,
    };

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.historyTitle,
          style: typography.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: feedbacksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (feedbacks) {
          if (feedbacks.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsetsDirectional.all(spacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        color: colors.surfaceSubtle,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.history_toggle_off_rounded,
                        size: 48.0,
                        color: colors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: spacing.lg),
                    Text(
                      l10n.emptyHistoryTitle,
                      style: typography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      l10n.emptyHistorySubtitle,
                      style: typography.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsetsDirectional.all(spacing.lg),
            itemCount: feedbacks.length,
            separatorBuilder: (_, _) => SizedBox(height: spacing.md),
            itemBuilder: (context, index) {
              final fb = feedbacks[index];
              final recipe = recipesMap[fb.recipeId];
              final kid = fb.kidId != null ? kidsMap[fb.kidId] : null;

              final avatarId = (kid?.notes != null && kid!.notes!.isNotEmpty)
                  ? kid.notes!
                  : 'avatar_chef';

              final dateStr = _formatFriendlyDate(context, fb.date);
              final reasonStr = _resolveReason(context, fb.reasonTag, fb.notes);

              final (
                reactionLabel,
                reactionEmoji,
                badgeColor,
                badgeBg,
              ) = switch (fb.reaction) {
                'loved' => (
                  l10n.reactionLoved,
                  '😍',
                  colors.primary,
                  colors.primaryContainer,
                ),
                'ok' => (
                  l10n.reactionOk,
                  '🙂',
                  colors.secondary,
                  colors.secondaryContainer,
                ),
                'refused' => (
                  l10n.reactionRefused,
                  '🙁',
                  colors.error,
                  colors.errorContainer,
                ),
                _ => (
                  fb.reaction,
                  '🍽️',
                  colors.textSecondary,
                  colors.surfaceSubtle,
                ),
              };

              return InkWell(
                onTap: recipe != null
                    ? () => context.push('/recipe/${recipe.id}')
                    : null,
                borderRadius: BorderRadius.circular(radii.card),
                child: Container(
                  padding: EdgeInsetsDirectional.all(spacing.md),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(radii.card),
                    border: Border.all(color: colors.borderSubtle),
                    boxShadow: [
                      BoxShadow(
                        color: colors.buttonShadow.withValues(alpha: 0.04),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Row: Recipe title & friendly date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.all(spacing.xs),
                            decoration: BoxDecoration(
                              color: colors.accentContainer,
                              borderRadius: BorderRadius.circular(radii.sm),
                            ),
                            child: Icon(
                              Icons.restaurant_rounded,
                              size: 18.0,
                              color: colors.accent,
                            ),
                          ),
                          SizedBox(width: spacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe?.title ?? fb.recipeId,
                                  style: typography.titleSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: spacing.xs / 2),
                                Text(
                                  dateStr,
                                  style: typography.bodySmall.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Reaction Badge
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: spacing.sm,
                              vertical: spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(radii.full),
                              border: Border.all(
                                color: badgeColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  reactionEmoji,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                                SizedBox(width: spacing.xs),
                                Text(
                                  reactionLabel,
                                  style: typography.labelSmall.copyWith(
                                    color: badgeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacing.sm),

                      // Kid info and Reason Tag
                      Row(
                        children: [
                          if (kid != null) ...[
                            KidAvatarBadge(avatarId: avatarId, size: 24.0),
                            SizedBox(width: spacing.xs),
                            Text(
                              kid.name,
                              style: typography.labelMedium.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: spacing.md),
                          ],
                          if (reasonStr.isNotEmpty)
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: spacing.sm,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(radii.full),
                                border: Border.all(color: colors.borderSubtle),
                              ),
                              child: Text(
                                reasonStr,
                                style: typography.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                  fontSize: 11.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
