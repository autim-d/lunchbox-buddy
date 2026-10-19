import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_recommendation.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';

/// Debug screen allowing developers and testers to inspect local SQLite recipes
/// and interactively test the rule-based recommendation engine offline.
class DebugRecipesScreen extends ConsumerStatefulWidget {
  const DebugRecipesScreen({super.key});

  @override
  ConsumerState<DebugRecipesScreen> createState() => _DebugRecipesScreenState();
}

class _DebugRecipesScreenState extends ConsumerState<DebugRecipesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _searchQuery = '';

  // Test suggestion state
  String _selectedAllergyPreset = 'nuts'; // 'none', 'nuts', 'milk', 'gluten'
  String _selectedMealType = 'lunchbox';
  String _selectedMoodTag = 'quick';
  int? _selectedMaxMinutes = 15;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatReason(String reasonKey, AppLocalizations l10n) {
    return switch (reasonKey) {
      'reason_ingredients_on_hand' => l10n.reasonIngredientsOnHand,
      'reason_kid_favorite' => l10n.reasonKidFavorite,
      'reason_hidden_veggies' => l10n.reasonHiddenVeggies,
      'reason_lunchbox_friendly' => l10n.reasonLunchboxFriendly,
      'reason_quick_prep' => l10n.reasonQuickPrep,
      _ => l10n.reasonBalancedMeal,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const typography = AppTokens.typography;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology_rounded),
            tooltip: 'فاحص Firebase AI Logic',
            onPressed: () => context.push('/ai-debug'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.secondary,
          unselectedLabelColor: colors.textSecondary,
          indicatorColor: colors.secondary,
          tabs: [
            Tab(text: l10n.debugRecipesTitle),
            Tab(text: l10n.testSuggestionsTitle),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllRecipesTab(l10n, colors),
          _buildTestSuggestionsTab(l10n, colors),
        ],
      ),
    );
  }

  Widget _buildAllRecipesTab(AppLocalizations l10n, AppColors colors) {
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final recipesAsync = ref.watch(allRecipesProvider);

    return SafeArea(
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
    );
  }

  Widget _buildTestSuggestionsTab(AppLocalizations l10n, AppColors colors) {
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    // Construct request based on selected test controls
    final testKid = KidProfile(
      id: 'test_child_debug',
      name: 'طفل الاختبار',
      birthDate: DateTime.now().subtract(const Duration(days: 365 * 5)), // 5yo
      allergies: switch (_selectedAllergyPreset) {
        'nuts' => const ['nuts'],
        'milk' => const ['milk'],
        'gluten' => const ['gluten'],
        _ => const [],
      },
      dislikes: const [],
      likes: const [],
    );

    final request = MealSuggestionRequest(
      selectedKids: [testKid],
      mealType: _selectedMealType,
      moodTags: [_selectedMoodTag],
      maxMinutes: _selectedMaxMinutes,
    );

    final recommendationsAsync = ref.watch(mealSuggestionsProvider(request));

    return ListView(
      padding: EdgeInsetsDirectional.all(spacing.lg),
      children: [
        // Title banner
        Container(
          padding: EdgeInsetsDirectional.all(spacing.md),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(radii.card),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.testSuggestionsTitle, style: typography.titleMedium),
              SizedBox(height: spacing.xs),
              Text(
                l10n.testSuggestionsDescription,
                style: typography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.lg),

        // Controls: Allergen filter test
        Text('1. اختبار الحساسيات:', style: typography.labelLarge),
        SizedBox(height: spacing.xs),
        Wrap(
          spacing: spacing.sm,
          children: [
            ChoiceChip(
              label: Text(l10n.filterNutAllergy),
              selected: _selectedAllergyPreset == 'nuts',
              onSelected: (val) =>
                  setState(() => _selectedAllergyPreset = 'nuts'),
            ),
            ChoiceChip(
              label: Text(l10n.filterMilkAllergy),
              selected: _selectedAllergyPreset == 'milk',
              onSelected: (val) =>
                  setState(() => _selectedAllergyPreset = 'milk'),
            ),
            ChoiceChip(
              label: Text(l10n.filterGlutenAllergy),
              selected: _selectedAllergyPreset == 'gluten',
              onSelected: (val) =>
                  setState(() => _selectedAllergyPreset = 'gluten'),
            ),
            ChoiceChip(
              label: Text(l10n.filterAllergiesNone),
              selected: _selectedAllergyPreset == 'none',
              onSelected: (val) =>
                  setState(() => _selectedAllergyPreset = 'none'),
            ),
          ],
        ),
        SizedBox(height: spacing.md),

        // Controls: Meal type & Max minutes
        Text('2. نوع الوجبة والوقت:', style: typography.labelLarge),
        SizedBox(height: spacing.xs),
        Wrap(
          spacing: spacing.sm,
          children: [
            ChoiceChip(
              label: const Text('Lunchbox (لانش بوكس)'),
              selected: _selectedMealType == 'lunchbox',
              onSelected: (val) =>
                  setState(() => _selectedMealType = 'lunchbox'),
            ),
            ChoiceChip(
              label: const Text('Breakfast (فطور)'),
              selected: _selectedMealType == 'breakfast',
              onSelected: (val) =>
                  setState(() => _selectedMealType = 'breakfast'),
            ),
            ChoiceChip(
              label: const Text('15 دقيقة كحد أقصى'),
              selected: _selectedMaxMinutes == 15,
              onSelected: (val) =>
                  setState(() => _selectedMaxMinutes = val ? 15 : null),
            ),
          ],
        ),
        SizedBox(height: spacing.md),

        // Controls: Mood tag
        Text('3. المزاج / التصنيف:', style: typography.labelLarge),
        SizedBox(height: spacing.xs),
        Wrap(
          spacing: spacing.sm,
          children: [
            ChoiceChip(
              label: const Text('#quick (سريع)'),
              selected: _selectedMoodTag == 'quick',
              onSelected: (val) => setState(() => _selectedMoodTag = 'quick'),
            ),
            ChoiceChip(
              label: const Text('#hidden-veggies (خضار مخفية)'),
              selected: _selectedMoodTag == 'hidden-veggies',
              onSelected: (val) =>
                  setState(() => _selectedMoodTag = 'hidden-veggies'),
            ),
            ChoiceChip(
              label: const Text('#fun (ممتع)'),
              selected: _selectedMoodTag == 'fun',
              onSelected: (val) => setState(() => _selectedMoodTag = 'fun'),
            ),
          ],
        ),
        SizedBox(height: spacing.xl),

        // Results section
        Text(
          l10n.topRecommendationsTitle,
          style: typography.titleLarge.copyWith(color: colors.secondary),
        ),
        SizedBox(height: spacing.md),

        recommendationsAsync.when(
          loading: () => Center(
            child: Padding(
              padding: EdgeInsetsDirectional.all(spacing.xl),
              child: CircularProgressIndicator(color: colors.accent),
            ),
          ),
          error: (err, stack) =>
              Center(child: Text(err.toString(), style: typography.bodyMedium)),
          data: (recommendations) {
            if (recommendations.isEmpty) {
              return Center(
                child: Text(l10n.noRecipesFound, style: typography.bodyMedium),
              );
            }

            return Column(
              children: recommendations.asMap().entries.map((entry) {
                final rank = entry.key + 1;
                final rec = entry.value;

                return _RecommendationCard(
                  rank: rank,
                  recommendation: rec,
                  reasonText: _formatReason(rec.reasonKey, l10n),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.rank,
    required this.recommendation,
    required this.reasonText,
  });

  final int rank;
  final MealRecommendation recommendation;
  final String reasonText;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;
    final recipe = recommendation.recipe;

    return Container(
      margin: EdgeInsetsDirectional.only(bottom: spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.card),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.buttonShadow.withValues(alpha: 0.05),
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
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: typography.labelLarge.copyWith(
                      color: colors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text(
                  recipe.title,
                  style: typography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: colors.accentContainer,
                  borderRadius: BorderRadius.circular(radii.sm),
                ),
                child: Text(
                  'نقاط: ${recommendation.score.toStringAsFixed(1)}',
                  style: typography.labelMedium.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          Text(
            recipe.description,
            style: typography.bodySmall.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: spacing.md),

          // Reason Pill
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: spacing.md,
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
                  Icons.auto_awesome_rounded,
                  color: colors.secondary,
                  size: 16.0,
                ),
                SizedBox(width: spacing.xs),
                Text(
                  reasonText,
                  style: typography.labelMedium.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.sm),

          // Breakdown info
          Text(
            'تفاصيل النقاط: ملائمة الوقت: ${recommendation.breakdown['timeFit']?.toStringAsFixed(1) ?? '0'}, تطابق التصنيف: ${recommendation.breakdown['tagMatch']?.toStringAsFixed(1) ?? '0'}',
            style: typography.bodySmall.copyWith(
              color: colors.textMuted,
              fontSize: 11.0,
            ),
          ),
        ],
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
