import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/app/locale_provider.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/kid_avatar_picker.dart';
import 'package:lunchbox_buddy/core/ui/ticket_clipper.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/saved_recipes_notifier.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_bottom_sheet.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';

/// Warm, tactile, uncluttered Home screen designed for a busy mother
/// with one hand free. Strictly RTL-first, zero hardcoded strings.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting(BuildContext context) {
    final l10n = context.l10n;
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return l10n.greetingMorning;
    } else if (hour < 17) {
      return l10n.greetingAfternoon;
    } else {
      return l10n.greetingEvening;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final currentLocale = ref.watch(appLocaleProvider);
    final isArabic = currentLocale.languageCode == 'ar';

    final kidsAsync = ref.watch(kidsListNotifierProvider);
    final selectedKidIds = ref.watch(selectedKidIdsProvider);
    final savedRecipesAsync = ref.watch(savedRecipesListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: typography.titleLarge.copyWith(color: colors.textPrimary),
        ),
        actions: [
          // Language Switch
          Padding(
            padding: EdgeInsetsDirectional.only(end: spacing.xs),
            child: ActionChip(
              avatar: Icon(
                Icons.language_rounded,
                size: 16.0,
                color: colors.secondary,
              ),
              label: Text(
                isArabic ? l10n.english : l10n.arabic,
                style: typography.labelSmall.copyWith(color: colors.secondary),
              ),
              backgroundColor: colors.secondaryContainer,
              side: BorderSide(color: colors.secondary.withValues(alpha: 0.2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radii.full),
              ),
              onPressed: () {
                ref.read(appLocaleProvider.notifier).toggleLocale();
              },
            ),
          ),

          // Meal History Screen Link
          IconButton(
            icon: Icon(Icons.history_rounded, color: colors.textSecondary),
            tooltip: l10n.historyTitle,
            onPressed: () => context.push('/history'),
          ),

          // Debug Recipes Screen Link
          IconButton(
            icon: Icon(Icons.menu_book_rounded, color: colors.textSecondary),
            tooltip: l10n.viewDebugRecipes,
            onPressed: () => context.push('/debug-recipes'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Warm Greeting Banner
              Container(
                padding: EdgeInsetsDirectional.all(spacing.lg),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          size: 20.0,
                          color: colors.accent,
                        ),
                        SizedBox(width: spacing.sm),
                        Expanded(
                          child: Text(
                            _getGreeting(context),
                            style: typography.titleLarge.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      l10n.homePlaceholderTitle,
                      style: typography.titleSmall.copyWith(
                        color: colors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      l10n.appSubtitle,
                      style: typography.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.xl),

              // 2. Kid Selector (Avatars, Multi-select)
              kidsAsync.when(
                data: (kids) {
                  if (kids.isEmpty) return const SizedBox.shrink();

                  final allSelected = kids.every(
                    (k) => selectedKidIds.contains(k.id),
                  );

                  return Container(
                    padding: EdgeInsetsDirectional.all(spacing.md),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(radii.card),
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              l10n.cookingForWhom,
                              style: typography.labelLarge.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => context.push('/kids'),
                              icon: Icon(
                                Icons.tune_rounded,
                                size: 16.0,
                                color: colors.secondary,
                              ),
                              label: Text(
                                l10n.kidsManagementTitle,
                                style: typography.labelMedium.copyWith(
                                  color: colors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.sm),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // "All kids" chip
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                  end: spacing.sm,
                                ),
                                child: FilterChip(
                                  avatar: Icon(
                                    Icons.people_alt_rounded,
                                    size: 16.0,
                                    color: allSelected
                                        ? colors.secondary
                                        : colors.textSecondary,
                                  ),
                                  label: Text(l10n.allKidsOption),
                                  selected: allSelected,
                                  selectedColor: colors.secondaryContainer,
                                  backgroundColor: colors.surfaceSubtle,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      radii.full,
                                    ),
                                    side: BorderSide(
                                      color: allSelected
                                          ? colors.secondary
                                          : colors.border,
                                    ),
                                  ),
                                  onSelected: (_) {
                                    HapticFeedback.selectionClick();
                                    ref
                                        .read(selectedKidIdsProvider.notifier)
                                        .selectAll(kids.map((k) => k.id));
                                  },
                                ),
                              ),

                              // Individual Kid chips
                              ...kids.map((kid) {
                                final isSelected = selectedKidIds.contains(
                                  kid.id,
                                );
                                final avatarId =
                                    (kid.notes != null && kid.notes!.isNotEmpty)
                                    ? kid.notes!
                                    : 'avatar_chef';

                                return Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    end: spacing.sm,
                                  ),
                                  child: FilterChip(
                                    avatar: KidAvatarBadge(
                                      avatarId: avatarId,
                                      size: 24.0,
                                    ),
                                    label: Text(kid.name),
                                    selected: isSelected,
                                    selectedColor: colors.secondaryContainer,
                                    backgroundColor: colors.surfaceSubtle,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        radii.full,
                                      ),
                                      side: BorderSide(
                                        color: isSelected
                                            ? colors.secondary
                                            : colors.border,
                                      ),
                                    ),
                                    onSelected: (_) {
                                      HapticFeedback.selectionClick();
                                      ref
                                          .read(selectedKidIdsProvider.notifier)
                                          .toggleKid(kid.id);
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              SizedBox(height: spacing.xl),

              // 3. One Large Tactile Primary Button ("اقترحي لي وجبة")
              AppButton(
                label: l10n.suggestMealButton,
                icon: Icons.lunch_dining_rounded,
                onPressed: () {
                  SuggestBottomSheet.show(context);
                },
              ),
              SizedBox(height: spacing.xxl),

              // 4. Saved Recipes Row
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: spacing.sm,
                runSpacing: spacing.xs,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.savedRecipesSectionTitle,
                        style: typography.titleMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: spacing.xs),
                      Icon(
                        Icons.bookmark_rounded,
                        size: 20.0,
                        color: colors.accent,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.push('/saved-recipes'),
                    child: Text(
                      l10n.viewAllSavedRecipes,
                      style: typography.labelMedium.copyWith(
                        color: colors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.sm),

              savedRecipesAsync.when(
                data: (savedRecipes) {
                  if (savedRecipes.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.all(spacing.lg),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(radii.card),
                        border: Border.all(color: colors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            size: 32.0,
                            color: colors.textMuted,
                          ),
                          SizedBox(height: spacing.xs),
                          Text(
                            l10n.noSavedRecipesTitle,
                            style: typography.labelLarge.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: spacing.xs),
                          Text(
                            l10n.noSavedRecipesSubtitle,
                            style: typography.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return SizedBox(
                    height: 140.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: savedRecipes.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: spacing.md),
                      itemBuilder: (context, index) {
                        final recipe = savedRecipes[index];
                        return _SavedRecipeMiniCard(
                          recipe: recipe,
                          onTap: () {
                            context.push('/recipe/${recipe.id}', extra: recipe);
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(radii.card),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mini lunch ticket card for the Saved Recipes row
class _SavedRecipeMiniCard extends StatelessWidget {
  const _SavedRecipeMiniCard({required this.recipe, required this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;
    final totalMinutes = recipe.prepMinutes + recipe.cookMinutes;

    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.card),
        border: Border.all(color: colors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: colors.buttonShadow.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipPath(
        clipper: const PerforatedTicketClipper(
          borderRadius: 16.0,
          notchRadius: 8.0,
          notchY: 40.0,
        ),
        child: Material(
          color: colors.surface,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsetsDirectional.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: spacing.xs,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: colors.secondaryContainer,
                          borderRadius: BorderRadius.circular(radii.full),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 12.0,
                              color: colors.secondary,
                            ),
                            SizedBox(width: spacing.xs),
                            Text(
                              '$totalMinutes د',
                              style: typography.labelSmall.copyWith(
                                color: colors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.bookmark_rounded,
                        size: 16.0,
                        color: colors.accent,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    recipe.title,
                    style: typography.labelMedium.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 12.0,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
