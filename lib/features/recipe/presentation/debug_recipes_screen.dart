import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

/// Temporary debug screen that lists recipes directly from the local Drift
/// SQLite database without any network connection.
///
/// Strictly RTL-first, EdgeInsetsDirectional only, no hardcoded strings/colors.
class DebugRecipesScreen extends ConsumerStatefulWidget {
  const DebugRecipesScreen({super.key});

  @override
  ConsumerState<DebugRecipesScreen> createState() => _DebugRecipesScreenState();
}

class _DebugRecipesScreenState extends ConsumerState<DebugRecipesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final recipesAsync = ref.watch(allRecipesProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.debugRecipesTitle,
          style: typography.titleLarge.copyWith(color: colors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: recipesAsync.when(
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: colors.accent),
                SizedBox(height: spacing.lg),
                Text(
                  l10n.loadingRecipes,
                  style: typography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          error: (err, stack) => Center(
            child: Padding(
              padding: EdgeInsetsDirectional.all(spacing.lg),
              child: Text(
                err.toString(),
                style: typography.bodyMedium.copyWith(color: colors.error),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (allRecipes) {
            final filtered = _searchQuery.isEmpty
                ? allRecipes
                : allRecipes.where((r) {
                    final q = _searchQuery.toLowerCase();
                    return r.title.toLowerCase().contains(q) ||
                        r.description.toLowerCase().contains(q) ||
                        r.tags.any((t) => t.toLowerCase().contains(q));
                  }).toList();

            return Column(
              children: [
                // Top Header Badge
                Container(
                  width: double.infinity,
                  color: colors.surfaceSubtle,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: spacing.lg,
                    vertical: spacing.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.all(spacing.sm),
                        decoration: BoxDecoration(
                          color: colors.secondaryContainer,
                          borderRadius: BorderRadius.circular(radii.sm),
                        ),
                        child: Icon(
                          Icons.storage_rounded,
                          color: colors.secondary,
                          size: 20.0,
                        ),
                      ),
                      SizedBox(width: spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.totalRecipesCount(allRecipes.length),
                              style: typography.labelLarge.copyWith(
                                color: colors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.debugRecipesSubtitle,
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

                // Search box
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: spacing.lg,
                    vertical: spacing.md,
                  ),
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: l10n.suggestMealButton,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: colors.textSecondary,
                      ),
                      filled: true,
                      fillColor: colors.surface,
                      contentPadding: EdgeInsetsDirectional.symmetric(
                        horizontal: spacing.md,
                        vertical: spacing.sm,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radii.card),
                        borderSide: BorderSide(color: colors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radii.card),
                        borderSide: BorderSide(color: colors.border),
                      ),
                    ),
                  ),
                ),

                // Recipe list
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noRecipesFound,
                            style: typography.bodyMedium,
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsetsDirectional.all(spacing.lg),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: spacing.md),
                          itemBuilder: (context, index) {
                            final recipe = filtered[index];
                            return _RecipeCard(recipe: recipe);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.card),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.buttonShadow.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: EdgeInsetsDirectional.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  recipe.title,
                  style: typography.titleMedium.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.accentContainer,
                  borderRadius: BorderRadius.circular(radii.full),
                ),
                child: Text(
                  l10n.prepMinutesLabel(recipe.prepMinutes),
                  style: typography.labelMedium.copyWith(
                    color: colors.accent,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(
            recipe.description,
            style: typography.bodySmall.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: spacing.md),

          // Meta indicators
          Wrap(
            spacing: spacing.sm,
            runSpacing: spacing.xs,
            children: [
              _InfoPill(
                icon: Icons.kitchen_rounded,
                text: l10n.ingredientsCountLabel(recipe.ingredients.length),
                colors: colors,
                spacing: spacing,
                typography: typography,
              ),
              _InfoPill(
                icon: Icons.format_list_numbered_rounded,
                text: l10n.stepsCountLabel(recipe.steps.length),
                colors: colors,
                spacing: spacing,
                typography: typography,
              ),
              if (recipe.cookMinutes > 0)
                _InfoPill(
                  icon: Icons.timer_outlined,
                  text: l10n.cookMinutesLabel(recipe.cookMinutes),
                  colors: colors,
                  spacing: spacing,
                  typography: typography,
                ),
            ],
          ),
          SizedBox(height: spacing.md),

          // Tags row
          Wrap(
            spacing: spacing.xs,
            runSpacing: spacing.xs,
            children: recipe.tags.map((tag) {
              return Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(radii.sm),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Text(
                  '#$tag',
                  style: typography.labelMedium.copyWith(
                    color: colors.textSecondary,
                    fontSize: 11.0,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.text,
    required this.colors,
    required this.spacing,
    required this.typography,
  });

  final IconData icon;
  final String text;
  final AppColors colors;
  final AppSpacing spacing;
  final AppTypography typography;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(AppTokens.radii.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.0, color: colors.secondary),
          SizedBox(width: spacing.xs),
          Text(
            text,
            style: typography.labelMedium.copyWith(
              color: colors.secondary,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
