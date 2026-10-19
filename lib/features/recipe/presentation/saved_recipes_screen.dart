import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/recipe_category_illustration.dart';
import 'package:lunchbox_buddy/core/ui/ticket_clipper.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/saved_recipes_notifier.dart';

/// Screen displaying all offline saved recipes with quick remove & undo action
class SavedRecipesScreen extends ConsumerWidget {
  const SavedRecipesScreen({super.key});

  void _removeRecipe(BuildContext context, WidgetRef ref, Recipe recipe) {
    HapticFeedback.lightImpact();
    ref.read(savedRecipeIdsProvider.notifier).removeRecipe(recipe.id);

    final l10n = context.l10n;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.recipeRemovedFromSaved),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () {
            ref.read(savedRecipeIdsProvider.notifier).saveRecipe(recipe.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    final savedRecipesAsync = ref.watch(savedRecipesListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.savedRecipesSectionTitle,
          style: typography.titleMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: savedRecipesAsync.when(
          data: (recipes) {
            if (recipes.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.all(spacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 88.0,
                        height: 88.0,
                        decoration: BoxDecoration(
                          color: colors.accentContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bookmark_border_rounded,
                          size: 44.0,
                          color: colors.accent,
                        ),
                      ),
                      SizedBox(height: spacing.lg),
                      Text(
                        l10n.noSavedRecipesTitle,
                        style: typography.titleLarge.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        l10n.noSavedRecipesSubtitle,
                        style: typography.bodyMedium.copyWith(
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing.xl),
                      AppButton(
                        label: l10n.suggestMealButton,
                        icon: Icons.lunch_dining_rounded,
                        onPressed: () => context.go('/home'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsetsDirectional.all(spacing.lg),
              itemCount: recipes.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: spacing.md),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return _SavedRecipeItem(
                  recipe: recipe,
                  onTap: () {
                    context.push('/recipe/${recipe.id}', extra: recipe);
                  },
                  onRemove: () => _removeRecipe(context, ref, recipe),
                );
              },
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, _) => Center(
            child: Text(
              l10n.errorResultsTitle,
              style: typography.bodyMedium.copyWith(color: colors.error),
            ),
          ),
        ),
      ),
    );
  }
}

class _SavedRecipeItem extends StatelessWidget {
  const _SavedRecipeItem({
    required this.recipe,
    required this.onTap,
    required this.onRemove,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;
    final totalMinutes = recipe.prepMinutes + recipe.cookMinutes;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.card),
        border: Border.all(color: colors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: colors.buttonShadow.withValues(alpha: 0.05),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipPath(
        clipper: const PerforatedTicketClipper(
          borderRadius: 20.0,
          notchRadius: 10.0,
          notchY: 60.0,
        ),
        child: Material(
          color: colors.surface,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsetsDirectional.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top ticket bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: spacing.sm,
                              vertical: 3.0,
                            ),
                            decoration: BoxDecoration(
                              color: colors.secondaryContainer,
                              borderRadius: BorderRadius.circular(radii.full),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 13.0,
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
                          SizedBox(width: spacing.sm),
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: spacing.sm,
                              vertical: 3.0,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(radii.full),
                              border: Border.all(color: colors.borderSubtle),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  size: 13.0,
                                  color: colors.secondary,
                                ),
                                SizedBox(width: spacing.xs),
                                Text(
                                  'حلال',
                                  style: typography.labelSmall.copyWith(
                                    color: colors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Remove button
                      IconButton(
                        icon: Icon(
                          Icons.bookmark_remove_outlined,
                          size: 20.0,
                          color: colors.textMuted,
                        ),
                        tooltip: l10n.remove,
                        onPressed: onRemove,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.sm),

                  // Content Row: Category Illustration + Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Illustration thumbnail with Hero transition
                      ClipRRect(
                        borderRadius: BorderRadius.circular(radii.md),
                        child: SizedBox(
                          width: 80.0,
                          height: 80.0,
                          child: RecipeCategoryIllustration(
                            recipe: recipe,
                            height: 80.0,
                            borderRadius: BorderRadius.circular(radii.md),
                            enableHero: false,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.md),

                      // Details
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              recipe.description,
                              style: typography.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
