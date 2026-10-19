import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/kid_avatar_picker.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';

/// Finish screen with cheerful celebration animation and "Did they eat it?" feedback loop
class CookCelebrationView extends ConsumerStatefulWidget {
  const CookCelebrationView({super.key, required this.recipe});

  final Recipe recipe;

  @override
  ConsumerState<CookCelebrationView> createState() =>
      _CookCelebrationViewState();
}

class _CookCelebrationViewState extends ConsumerState<CookCelebrationView> {
  // kidId -> reaction ('loved', 'ok', 'refused')
  final Map<String, String> _reactions = {};
  // kidId -> reasonTag ('too_spicy', 'texture', 'disliked_ingredient', 'not_hungry')
  final Map<String, String?> _reasons = {};
  // kidId -> ingredientId
  final Map<String, String> _dislikedIngredients = {};
  bool _isSaving = false;

  void _onSelectReaction(String kidId, String reaction) {
    unawaited(HapticFeedback.lightImpact());
    setState(() {
      if (_reactions[kidId] == reaction) {
        _reactions.remove(kidId);
        _reasons.remove(kidId);
      } else {
        _reactions[kidId] = reaction;
      }
    });
  }

  void _onSelectReason(String kidId, String reasonTag, KidProfile kid) {
    unawaited(HapticFeedback.lightImpact());
    if (reasonTag == 'disliked_ingredient') {
      _showDislikedIngredientFlow(kid);
      return;
    }

    setState(() {
      if (_reasons[kidId] == reasonTag) {
        _reasons.remove(kidId);
      } else {
        _reasons[kidId] = reasonTag;
      }
    });
  }

  Future<void> _showDislikedIngredientFlow(KidProfile kid) async {
    final l10n = context.l10n;
    final allIngredients =
        ref.read(allIngredientsProvider).asData?.value ?? const <Ingredient>[];
    final ingredientNameMap = {
      for (final ing in allIngredients) ing.id: ing.nameAr,
    };

    // 1. Choose which ingredient was disliked
    final chosenIngredientId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        const colors = AppTokens.colors;
        const spacing = AppTokens.spacing;
        const radii = AppTokens.radii;
        const typography = AppTokens.typography;

        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(radii.card),
            ),
          ),
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.whichIngredientPrompt,
                style: typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.md),
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                alignment: WrapAlignment.center,
                children: widget.recipe.ingredients.map((ing) {
                  final name =
                      ingredientNameMap[ing.ingredientId] ??
                      ing.displayText ??
                      ing.ingredientId;
                  return ActionChip(
                    label: Text(name),
                    onPressed: () => Navigator.of(ctx).pop(ing.ingredientId),
                  );
                }).toList(),
              ),
              SizedBox(height: spacing.lg),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: Text(l10n.cancel),
              ),
            ],
          ),
        );
      },
    );

    if (chosenIngredientId == null || !mounted) return;

    final ingredientDisplayName =
        ingredientNameMap[chosenIngredientId] ?? chosenIngredientId;

    // 2. Confirmation Dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.addDislikeConfirmTitle),
          content: Text(
            l10n.addDislikeConfirmMessage(ingredientDisplayName, kid.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.confirmAddDislike),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      // Add to kid's soft dislikes in Drift
      final currentDislikes = Set<String>.from(kid.dislikes);
      currentDislikes.add(chosenIngredientId);
      final updatedKid = kid.copyWith(dislikes: currentDislikes.toList());
      await ref.read(kidsListNotifierProvider.notifier).updateKid(updatedKid);

      setState(() {
        _reasons[kid.id] = 'disliked_ingredient';
        _dislikedIngredients[kid.id] = chosenIngredientId;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.dislikeAddedSnackbar(ingredientDisplayName, kid.name),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _saveAndExit() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final l10n = context.l10n;
    final now = DateTime.now();

    for (final entry in _reactions.entries) {
      final kidId = entry.key;
      final reaction = entry.value;
      final reasonTag = _reasons[kidId];
      final dislikedIng = _dislikedIngredients[kidId];

      final feedback = MealFeedback(
        id: 'fb_${now.microsecondsSinceEpoch}_$kidId',
        recipeId: widget.recipe.id,
        kidId: kidId,
        reaction: reaction,
        reasonTag: reasonTag,
        date: now,
        notes: dislikedIng,
      );

      await ref
          .read(feedbackListNotifierProvider.notifier)
          .addFeedback(feedback);
    }

    if (mounted) {
      if (_reactions.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.feedbackSavedToast),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      try {
        context.go('/home');
      } catch (_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final allKids =
        ref.watch(kidsListNotifierProvider).asData?.value ??
        const <KidProfile>[];
    final selectedIds = ref.watch(selectedKidIdsProvider);

    final activeKids = selectedIds.isNotEmpty
        ? allKids.where((k) => selectedIds.contains(k.id)).toList()
        : allKids;

    Widget badgeContent = Container(
      width: 104.0,
      height: 104.0,
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        shape: BoxShape.circle,
        border: Border.all(color: colors.secondary, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(Icons.verified_rounded, size: 56.0, color: colors.secondary),
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
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: spacing.md),
              Center(child: badgeContent),
              SizedBox(height: spacing.md),

              // Celebration Title
              Text(
                l10n.celebrationTitle,
                style: typography.displayMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.xs),

              // Subtitle
              Text(
                l10n.celebrationSubtitle,
                style: typography.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.lg),

              // Recipe Header Summary Card
              Container(
                padding: EdgeInsetsDirectional.all(spacing.md),
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
                        size: 22.0,
                        color: colors.accent,
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipe.title,
                            style: typography.titleSmall.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.recipe.servings} حصة • ${widget.recipe.prepMinutes + widget.recipe.cookMinutes} دقيقة',
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
              SizedBox(height: spacing.lg),

              // "Did they eat it?" Section Header
              Text(
                l10n.feedbackPrompt,
                style: typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: spacing.sm),

              // Per-Kid Feedback Cards
              if (activeKids.isNotEmpty)
                ...activeKids.map((kid) {
                  final reaction = _reactions[kid.id];
                  final reason = _reasons[kid.id];
                  final avatarId = (kid.notes != null && kid.notes!.isNotEmpty)
                      ? kid.notes!
                      : 'avatar_chef';

                  return Container(
                    margin: EdgeInsetsDirectional.only(bottom: spacing.md),
                    padding: EdgeInsetsDirectional.all(spacing.md),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(radii.card),
                      border: Border.all(
                        color: reaction != null
                            ? colors.primary.withValues(alpha: 0.4)
                            : colors.borderSubtle,
                      ),
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
                        // Kid Info Header
                        Row(
                          children: [
                            KidAvatarBadge(avatarId: avatarId, size: 36.0),
                            SizedBox(width: spacing.sm),
                            Expanded(
                              child: Text(
                                kid.name,
                                style: typography.titleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.sm),

                        // Three Large Reaction Buttons
                        Row(
                          children: [
                            // 1. Loved
                            Expanded(
                              child: _ReactionButton(
                                label: l10n.reactionLoved,
                                emoji: '😍',
                                isSelected: reaction == 'loved',
                                activeColor: colors.primary,
                                activeBackground: colors.primaryContainer,
                                onTap: () => _onSelectReaction(kid.id, 'loved'),
                              ),
                            ),
                            SizedBox(width: spacing.xs),
                            // 2. OK
                            Expanded(
                              child: _ReactionButton(
                                label: l10n.reactionOk,
                                emoji: '🙂',
                                isSelected: reaction == 'ok',
                                activeColor: colors.secondary,
                                activeBackground: colors.secondaryContainer,
                                onTap: () => _onSelectReaction(kid.id, 'ok'),
                              ),
                            ),
                            SizedBox(width: spacing.xs),
                            // 3. Refused
                            Expanded(
                              child: _ReactionButton(
                                label: l10n.reactionRefused,
                                emoji: '🙁',
                                isSelected: reaction == 'refused',
                                activeColor: colors.error,
                                activeBackground: colors.errorContainer,
                                onTap: () =>
                                    _onSelectReaction(kid.id, 'refused'),
                              ),
                            ),
                          ],
                        ),

                        // Optional Reason Chips
                        if (reaction != null) ...[
                          SizedBox(height: spacing.sm),
                          Wrap(
                            spacing: spacing.xs,
                            runSpacing: spacing.xs,
                            children: [
                              _ReasonChip(
                                label: l10n.reasonTooSpicy,
                                isSelected: reason == 'too_spicy',
                                onTap: () =>
                                    _onSelectReason(kid.id, 'too_spicy', kid),
                              ),
                              _ReasonChip(
                                label: l10n.reasonTexture,
                                isSelected: reason == 'texture',
                                onTap: () =>
                                    _onSelectReason(kid.id, 'texture', kid),
                              ),
                              _ReasonChip(
                                label: l10n.reasonDislikedIngredient,
                                isSelected: reason == 'disliked_ingredient',
                                onTap: () => _onSelectReason(
                                  kid.id,
                                  'disliked_ingredient',
                                  kid,
                                ),
                              ),
                              _ReasonChip(
                                label: l10n.reasonNotHungry,
                                isSelected: reason == 'not_hungry',
                                onTap: () =>
                                    _onSelectReason(kid.id, 'not_hungry', kid),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                }),

              SizedBox(height: spacing.md),

              // Save & Continue Button
              AppButton(
                label: l10n.saveFeedbackAndDone,
                icon: Icons.check_circle_outline_rounded,
                isLoading: _isSaving,
                onPressed: _saveAndExit,
              ),
              SizedBox(height: spacing.sm),

              // Skip / Back to Home Button
              TextButton(
                onPressed: () {
                  try {
                    context.go('/home');
                  } catch (_) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text(
                  l10n.backToHome,
                  style: typography.labelLarge.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.activeColor,
    required this.activeBackground,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final bool isSelected;
  final Color activeColor;
  final Color activeBackground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radii.card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: spacing.xs,
          vertical: spacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeBackground : colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(radii.card),
          border: Border.all(
            color: isSelected ? activeColor : colors.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24.0)),
            SizedBox(height: spacing.xs),
            Text(
              label,
              style: typography.labelSmall.copyWith(
                color: isSelected ? activeColor : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radii.full),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: spacing.sm,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryContainer : colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(radii.full),
          border: Border.all(
            color: isSelected ? colors.primary : colors.borderSubtle,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: typography.labelSmall.copyWith(
            color: isSelected ? colors.primary : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
