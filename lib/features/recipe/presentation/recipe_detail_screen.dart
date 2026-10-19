import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/dynamic_save_button.dart';
import 'package:lunchbox_buddy/core/ui/recipe_category_illustration.dart';
import 'package:lunchbox_buddy/core/ui/scroll_fade_container.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/core/utils/quantity_formatter.dart';
import 'package:lunchbox_buddy/features/grocery/presentation/grocery_notifier.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/saved_recipes_notifier.dart';

/// Screen displaying complete details for a recipe, including:
/// - Category placeholder illustration with Hero transition
/// - Servings stepper that scales all ingredient quantities dynamically (Western digits)
/// - Ingredient checklist with "I have it" checkboxes and soft scroll-fade edge
/// - Add missing items to grocery list stub
/// - Dynamic Save button (Save -> Saved with smooth animated width morph)
/// - Start cooking CTA
class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    this.initialRecipe,
  });

  final String recipeId;
  final Recipe? initialRecipe;

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  int _currentServings = 1;
  final Set<String> _haveIngredients = <String>{};
  bool _initialized = false;

  void _initServings(Recipe recipe) {
    if (!_initialized) {
      _currentServings = recipe.servings > 0 ? recipe.servings : 1;
      _initialized = true;
    }
  }

  void _incrementServings() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentServings++;
    });
  }

  void _decrementServings() {
    if (_currentServings <= 1) return;
    HapticFeedback.lightImpact();
    setState(() {
      _currentServings--;
    });
  }

  void _toggleIngredient(String ingredientId) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_haveIngredients.contains(ingredientId)) {
        _haveIngredients.remove(ingredientId);
      } else {
        _haveIngredients.add(ingredientId);
      }
    });
  }

  String _formatUnit(String? unit) {
    if (unit == null || unit.isEmpty) return '';
    return switch (unit.toLowerCase()) {
      'tbsp' => 'ملعقة كبيرة',
      'tsp' => 'ملعقة صغيرة',
      'cup' => 'كوب',
      'piece' => 'حبة',
      'pieces' => 'حبات',
      'slices' => 'شريحة',
      'slice' => 'شريحة',
      'g' => 'جرام',
      'ml' => 'مل',
      'leaves' => 'أوراق',
      'pinch' => 'رشة',
      _ => unit,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    // Use initialRecipe if provided, otherwise resolve via recipeByIdProvider
    final asyncRecipe = ref.watch(recipeByIdProvider(widget.recipeId));
    final recipe = widget.initialRecipe ?? asyncRecipe.asData?.value;

    if (recipe == null) {
      if (asyncRecipe.isLoading) {
        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: const Center(child: CircularProgressIndicator.adaptive()),
        );
      }

      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(spacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 48.0,
                  color: colors.textMuted,
                ),
                SizedBox(height: spacing.md),
                Text(
                  l10n.emptyResultsTitle,
                  style: typography.titleMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    _initServings(recipe);

    final totalMinutes = recipe.prepMinutes + recipe.cookMinutes;
    final totalIngredients = recipe.ingredients.length;
    final haveCount = _haveIngredients.length;
    final missingCount = (totalIngredients - haveCount).clamp(
      0,
      totalIngredients,
    );

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
          l10n.recipeDetailTitle,
          style: typography.titleMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(
                  start: spacing.lg,
                  end: spacing.lg,
                  top: spacing.md,
                  bottom: spacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header Illustration (with Hero)
                    RecipeCategoryIllustration(
                      recipe: recipe,
                      height: 200.0,
                      borderRadius: BorderRadius.circular(radii.card),
                    ),
                    SizedBox(height: spacing.lg),

                    // 2. Title & Description
                    Text(
                      recipe.title,
                      style: typography.displayMedium.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      recipe.description,
                      style: typography.bodyMedium.copyWith(
                        color: colors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: spacing.md),

                    // 3. Tags Wrap
                    Wrap(
                      spacing: spacing.xs,
                      runSpacing: spacing.xs,
                      children: [
                        _DetailTagBadge(
                          label: 'حلال 100%',
                          icon: Icons.verified_rounded,
                          color: colors.secondary,
                        ),
                        ...recipe.tags.map((tag) {
                          return _DetailTagBadge(
                            label: '#$tag',
                            color: colors.textSecondary,
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: spacing.lg),

                    // 4. Meta Card: Times & Servings Stepper
                    Container(
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
                        children: [
                          // Time Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _TimeInfoItem(
                                icon: Icons.timer_outlined,
                                title: 'التحضير',
                                value: '${recipe.prepMinutes} د',
                              ),
                              Container(
                                height: 32.0,
                                width: 1.0,
                                color: colors.borderSubtle,
                              ),
                              _TimeInfoItem(
                                icon: Icons.soup_kitchen_outlined,
                                title: 'الطهي',
                                value: '${recipe.cookMinutes} د',
                              ),
                              Container(
                                height: 32.0,
                                width: 1.0,
                                color: colors.borderSubtle,
                              ),
                              _TimeInfoItem(
                                icon: Icons.schedule_rounded,
                                title: 'المجموع',
                                value: '$totalMinutes د',
                                isHighlight: true,
                              ),
                            ],
                          ),
                          Divider(
                            height: spacing.xl,
                            color: colors.borderSubtle,
                          ),

                          // Servings Stepper Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people_outline_rounded,
                                    size: 20.0,
                                    color: colors.secondary,
                                  ),
                                  SizedBox(width: spacing.xs),
                                  Text(
                                    l10n.servingsLabel,
                                    style: typography.labelLarge.copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              // Tactile Servings Stepper (Western digits 0-9)
                              Container(
                                decoration: BoxDecoration(
                                  color: colors.surfaceSubtle,
                                  borderRadius: BorderRadius.circular(
                                    radii.full,
                                  ),
                                  border: Border.all(color: colors.border),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_rounded),
                                      iconSize: 18.0,
                                      color: _currentServings > 1
                                          ? colors.textPrimary
                                          : colors.textMuted,
                                      visualDensity: VisualDensity.compact,
                                      onPressed: _currentServings > 1
                                          ? _decrementServings
                                          : null,
                                      tooltip: 'تقليل الحصص',
                                    ),
                                    Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 32.0,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$_currentServings',
                                        style: typography.titleMedium.copyWith(
                                          color: colors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_rounded),
                                      iconSize: 18.0,
                                      color: colors.textPrimary,
                                      visualDensity: VisualDensity.compact,
                                      onPressed: _incrementServings,
                                      tooltip: 'زيادة الحصص',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing.xl),

                    // 5. Ingredients Section Header with On-Hand Counter
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: spacing.sm,
                      runSpacing: spacing.xs,
                      children: [
                        Text(
                          l10n.ingredientsSectionTitle,
                          style: typography.titleLarge.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: spacing.sm,
                            vertical: spacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: colors.secondaryContainer,
                            borderRadius: BorderRadius.circular(radii.full),
                          ),
                          child: Text(
                            l10n.ingredientsOnHandSummary(
                              haveCount,
                              totalIngredients,
                            ),
                            style: typography.labelSmall.copyWith(
                              color: colors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.sm),

                    // 6. Ingredients List with Soft Scroll-Fade Container
                    ScrollFadeContainer(
                      fadeHeight: 16.0,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipe.ingredients.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: spacing.xs),
                        itemBuilder: (context, index) {
                          final ing = recipe.ingredients[index];
                          final isChecked = _haveIngredients.contains(
                            ing.ingredientId,
                          );

                          // Scaled formatted quantity (Western digits & vulgar fractions e.g. 1/4, 1/2)
                          final scaledQtyStr = QuantityFormatter.format(
                            ing.quantity,
                            baseServings: recipe.servings,
                            targetServings: _currentServings,
                          );
                          final unitStr = _formatUnit(ing.unit);

                          return Container(
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? colors.secondaryContainer.withValues(
                                      alpha: 0.3,
                                    )
                                  : colors.surface,
                              borderRadius: BorderRadius.circular(radii.md),
                              border: Border.all(
                                color: isChecked
                                    ? colors.secondary.withValues(alpha: 0.4)
                                    : colors.borderSubtle,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(radii.md),
                                onTap: () =>
                                    _toggleIngredient(ing.ingredientId),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: spacing.sm,
                                    vertical: spacing.sm,
                                  ),
                                  child: Row(
                                    children: [
                                      // Checkbox "I have it"
                                      Checkbox(
                                        value: isChecked,
                                        activeColor: colors.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4.0,
                                          ),
                                        ),
                                        onChanged: (_) =>
                                            _toggleIngredient(ing.ingredientId),
                                      ),
                                      SizedBox(width: spacing.xs),

                                      // Ingredient Name & description
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ing.displayText != null &&
                                                      ing
                                                          .displayText!
                                                          .isNotEmpty
                                                  ? ing.displayText!
                                                  : ing.ingredientId,
                                              style: typography.bodyMedium
                                                  .copyWith(
                                                    color: isChecked
                                                        ? colors.textSecondary
                                                        : colors.textPrimary,
                                                    decoration: isChecked
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : null,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            if (ing.optional)
                                              Text(
                                                l10n.optionalIngredient,
                                                style: typography.labelSmall
                                                    .copyWith(
                                                      color: colors.textMuted,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      // Scaled Quantity Badge
                                      if (scaledQtyStr.isNotEmpty)
                                        Container(
                                          padding:
                                              EdgeInsetsDirectional.symmetric(
                                                horizontal: spacing.sm,
                                                vertical: 4.0,
                                              ),
                                          decoration: BoxDecoration(
                                            color: colors.surfaceSubtle,
                                            borderRadius: BorderRadius.circular(
                                              radii.sm,
                                            ),
                                            border: Border.all(
                                              color: colors.border,
                                            ),
                                          ),
                                          child: Text(
                                            unitStr.isNotEmpty
                                                ? '$scaledQtyStr $unitStr'
                                                : scaledQtyStr,
                                            style: typography.labelSmall
                                                .copyWith(
                                                  color: colors.textPrimary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: spacing.md),

                    // 7. Add Missing Items to Grocery List Action
                    if (missingCount > 0)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            ref
                                .read(groceryListNotifierProvider.notifier)
                                .addMissingFromRecipe(
                                  recipe: recipe,
                                  targetServings: _currentServings,
                                  tickedIngredientIds: _haveIngredients,
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.missingAddedToGrocerySnackbar,
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 4),
                                action: SnackBarAction(
                                  label: l10n.viewGroceryList,
                                  textColor: colors.accent,
                                  onPressed: () => context.push('/grocery'),
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.accent,
                            side: BorderSide(
                              color: colors.accent.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radii.md),
                            ),
                            padding: EdgeInsetsDirectional.symmetric(
                              vertical: spacing.md,
                            ),
                          ),
                          icon: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 18.0,
                          ),
                          label: Text(
                            l10n.addMissingToGrocery,
                            style: typography.labelLarge.copyWith(
                              color: colors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: spacing.xl),

                    // 8. Step-by-Step Preparation Steps
                    Text(
                      l10n.stepsSectionTitle,
                      style: typography.titleLarge.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.sm),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipe.steps.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: spacing.sm),
                      itemBuilder: (context, index) {
                        final stepText = recipe.steps[index];
                        final stepNumber = index + 1;

                        return Container(
                          padding: EdgeInsetsDirectional.all(spacing.md),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(radii.card),
                            border: Border.all(color: colors.borderSubtle),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Step Number Badge
                              Container(
                                width: 28.0,
                                height: 28.0,
                                decoration: BoxDecoration(
                                  color: colors.accentContainer,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$stepNumber',
                                  style: typography.labelMedium.copyWith(
                                    color: colors.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: spacing.md),

                              // Step Instruction
                              Expanded(
                                child: Text(
                                  stepText,
                                  style: typography.bodyMedium.copyWith(
                                    color: colors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 9. Bottom Pinned CTA Action Bar
            Container(
              padding: EdgeInsetsDirectional.all(spacing.md),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: colors.borderSubtle)),
                boxShadow: [
                  BoxShadow(
                    color: colors.buttonShadow.withValues(alpha: 0.06),
                    offset: const Offset(0, -2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: spacing.md,
                  runSpacing: spacing.sm,
                  children: [
                    // Dynamic Save Button
                    DynamicSaveButton(recipeId: recipe.id),

                    // Start Cooking Primary CTA
                    AppButton(
                      label: l10n.startCooking,
                      icon: Icons.soup_kitchen_rounded,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        context.push('/cook/${recipe.id}', extra: recipe);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTagBadge extends StatelessWidget {
  const _DetailTagBadge({required this.label, required this.color, this.icon});

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
            Icon(icon, size: 14.0, color: color),
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

class _TimeInfoItem extends StatelessWidget {
  const _TimeInfoItem({
    required this.icon,
    required this.title,
    required this.value,
    this.isHighlight = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    return Column(
      children: [
        Icon(
          icon,
          size: 18.0,
          color: isHighlight ? colors.accent : colors.textSecondary,
        ),
        SizedBox(height: spacing.xs),
        Text(
          title,
          style: typography.labelSmall.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 2.0),
        Text(
          value,
          style: typography.labelMedium.copyWith(
            color: isHighlight ? colors.accent : colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
