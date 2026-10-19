import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';

/// Modal bottom sheet allowing the mother to customize meal type, time,
/// mood tags, and optional on-hand ingredients before suggesting.
class SuggestBottomSheet extends ConsumerStatefulWidget {
  const SuggestBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuggestBottomSheet(),
    );
  }

  @override
  ConsumerState<SuggestBottomSheet> createState() => _SuggestBottomSheetState();
}

class _SuggestBottomSheetState extends ConsumerState<SuggestBottomSheet> {
  String _mealType = 'lunchbox';
  int _maxMinutes = 20;
  final Set<String> _moodTags = {'quick'};
  final Set<String> _selectedIngredientIds = {};
  String _ingredientSearchQuery = '';
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _ingredientSearchController =
      TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    _ingredientSearchController.dispose();
    super.dispose();
  }

  void _submit() {
    final allKids = ref.read(kidsListNotifierProvider).asData?.value ?? [];
    final selectedIds = ref.read(selectedKidIdsProvider);

    final selectedKids = allKids
        .where((k) => selectedIds.contains(k.id))
        .toList();

    // Fallback if none selected: take all kids
    final effectiveKids = selectedKids.isNotEmpty ? selectedKids : allKids;

    final request = MealSuggestionRequest(
      selectedKids: effectiveKids,
      availableIngredientIds: _selectedIngredientIds.isNotEmpty
          ? _selectedIngredientIds.toList()
          : null,
      maxMinutes: _maxMinutes,
      mealType: _mealType,
      moodTags: _moodTags.toList(),
      freeTextNote: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null,
    );

    ref.read(currentSuggestionRequestProvider.notifier).setRequest(request);

    Navigator.of(context).pop();
    context.push('/results');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final ingredientsAsync = ref.watch(allIngredientsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(radii.cardLg),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.buttonShadow.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Grab handle
              SizedBox(height: spacing.sm),
              Center(
                child: Container(
                  width: 44.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(radii.full),
                  ),
                ),
              ),
              SizedBox(height: spacing.sm),

              // Title Header
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.lg,
                  vertical: spacing.xs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.suggestSheetTitle,
                      style: typography.titleLarge.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: colors.textSecondary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Divider(color: colors.borderSubtle, height: 1.0),

              // Scrollable Options Form
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsetsDirectional.all(spacing.lg),
                  children: [
                    // Section 1: Meal Type
                    _SectionHeader(
                      title: l10n.mealTypeSectionTitle,
                      icon: Icons.restaurant_rounded,
                    ),
                    SizedBox(height: spacing.sm),
                    Wrap(
                      spacing: spacing.sm,
                      runSpacing: spacing.sm,
                      children: [
                        _FilterChipItem(
                          label: l10n.mealTypeLunchbox,
                          icon: Icons.lunch_dining_rounded,
                          isSelected: _mealType == 'lunchbox',
                          onSelected: () =>
                              setState(() => _mealType = 'lunchbox'),
                        ),
                        _FilterChipItem(
                          label: l10n.mealTypeBreakfast,
                          icon: Icons.wb_sunny_outlined,
                          isSelected: _mealType == 'breakfast',
                          onSelected: () =>
                              setState(() => _mealType = 'breakfast'),
                        ),
                        _FilterChipItem(
                          label: l10n.mealTypeDinner,
                          icon: Icons.nightlight_round_outlined,
                          isSelected: _mealType == 'dinner',
                          onSelected: () =>
                              setState(() => _mealType = 'dinner'),
                        ),
                        _FilterChipItem(
                          label: l10n.mealTypeSnack,
                          icon: Icons.cookie_outlined,
                          isSelected: _mealType == 'snack',
                          onSelected: () => setState(() => _mealType = 'snack'),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.xl),

                    // Section 2: Time Available
                    _SectionHeader(
                      title: l10n.timeSectionTitle,
                      icon: Icons.schedule_rounded,
                    ),
                    SizedBox(height: spacing.sm),
                    Wrap(
                      spacing: spacing.sm,
                      runSpacing: spacing.sm,
                      children: [
                        _FilterChipItem(
                          label: l10n.time10Min,
                          isSelected: _maxMinutes == 10,
                          onSelected: () => setState(() => _maxMinutes = 10),
                        ),
                        _FilterChipItem(
                          label: l10n.time20Min,
                          isSelected: _maxMinutes == 20,
                          onSelected: () => setState(() => _maxMinutes = 20),
                        ),
                        _FilterChipItem(
                          label: l10n.time30PlusMin,
                          isSelected: _maxMinutes >= 30,
                          onSelected: () => setState(() => _maxMinutes = 45),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.xl),

                    // Section 3: Mood Tags
                    _SectionHeader(
                      title: l10n.moodSectionTitle,
                      icon: Icons.mood_rounded,
                    ),
                    SizedBox(height: spacing.sm),
                    Wrap(
                      spacing: spacing.sm,
                      runSpacing: spacing.sm,
                      children: [
                        _FilterChipItem(
                          label: l10n.moodQuick,
                          icon: Icons.bolt_rounded,
                          isSelected: _moodTags.contains('quick'),
                          onSelected: () {
                            setState(() {
                              if (_moodTags.contains('quick')) {
                                _moodTags.remove('quick');
                              } else {
                                _moodTags.add('quick');
                              }
                            });
                          },
                        ),
                        _FilterChipItem(
                          label: l10n.moodPicky,
                          icon: Icons.child_care_rounded,
                          isSelected: _moodTags.contains('picky'),
                          onSelected: () {
                            setState(() {
                              if (_moodTags.contains('picky')) {
                                _moodTags.remove('picky');
                              } else {
                                _moodTags.add('picky');
                              }
                            });
                          },
                        ),
                        _FilterChipItem(
                          label: l10n.moodHiddenVeggies,
                          icon: Icons.eco_rounded,
                          isSelected: _moodTags.contains('hidden-veggies'),
                          onSelected: () {
                            setState(() {
                              if (_moodTags.contains('hidden-veggies')) {
                                _moodTags.remove('hidden-veggies');
                              } else {
                                _moodTags.add('hidden-veggies');
                              }
                            });
                          },
                        ),
                        _FilterChipItem(
                          label: l10n.moodFun,
                          icon: Icons.celebration_rounded,
                          isSelected: _moodTags.contains('fun'),
                          onSelected: () {
                            setState(() {
                              if (_moodTags.contains('fun')) {
                                _moodTags.remove('fun');
                              } else {
                                _moodTags.add('fun');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.xl),

                    // Section 4: Ingredients On Hand Picker
                    _SectionHeader(
                      title: l10n.ingredientsOnHandTitle,
                      icon: Icons.kitchen_rounded,
                      trailing: Text(
                        l10n.ingredientsOnHandOptional,
                        style: typography.bodySmall.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                    SizedBox(height: spacing.sm),

                    // Search field
                    TextField(
                      controller: _ingredientSearchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchIngredientsPlaceholder,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colors.textSecondary,
                        ),
                        suffixIcon: _ingredientSearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _ingredientSearchController.clear();
                                  setState(() => _ingredientSearchQuery = '');
                                },
                              )
                            : null,
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
                      onChanged: (val) {
                        setState(() => _ingredientSearchQuery = val.trim());
                      },
                    ),
                    SizedBox(height: spacing.sm),

                    // Ingredients chips list
                    ingredientsAsync.when(
                      data: (ingredients) {
                        final filtered = _ingredientSearchQuery.isEmpty
                            ? ingredients
                                  .where((i) => i.commonInRegion)
                                  .toList()
                            : ingredients
                                  .where(
                                    (i) =>
                                        i.nameAr.contains(
                                          _ingredientSearchQuery,
                                        ) ||
                                        i.nameEn.toLowerCase().contains(
                                          _ingredientSearchQuery.toLowerCase(),
                                        ),
                                  )
                                  .toList();

                        return Wrap(
                          spacing: spacing.xs,
                          runSpacing: spacing.xs,
                          children: filtered.take(16).map((ingredient) {
                            final isSelected = _selectedIngredientIds.contains(
                              ingredient.id,
                            );

                            return FilterChip(
                              label: Text(ingredient.nameAr),
                              selected: isSelected,
                              selectedColor: colors.secondaryContainer,
                              backgroundColor: colors.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(radii.full),
                                side: BorderSide(
                                  color: isSelected
                                      ? colors.secondary
                                      : colors.border,
                                ),
                              ),
                              onSelected: (selected) {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  if (selected) {
                                    _selectedIngredientIds.add(ingredient.id);
                                  } else {
                                    _selectedIngredientIds.remove(
                                      ingredient.id,
                                    );
                                  }
                                });
                              },
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                    SizedBox(height: spacing.xl),

                    // Section 5: Notes & Mic Row
                    _SectionHeader(
                      title: l10n.notesFieldLabel,
                      icon: Icons.edit_note_rounded,
                    ),
                    SizedBox(height: spacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _noteController,
                            decoration: InputDecoration(
                              hintText: l10n.notesFieldPlaceholder,
                              filled: true,
                              fillColor: colors.surface,
                              contentPadding: EdgeInsetsDirectional.all(
                                spacing.md,
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
                        SizedBox(width: spacing.sm),
                        // Mic Icon (disabled state for now)
                        Tooltip(
                          message: l10n.micVoiceDisabledTooltip,
                          child: Container(
                            width: AppTokens.touchTargets.min,
                            height: AppTokens.touchTargets.min,
                            decoration: BoxDecoration(
                              color: colors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(radii.card),
                              border: Border.all(color: colors.border),
                            ),
                            child: Icon(
                              Icons.mic_off_rounded,
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.xxl),
                  ],
                ),
              ),

              // Bottom Sticky Primary Button
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsetsDirectional.all(spacing.lg),
                  child: AppButton(
                    label: l10n.submitSuggestionButton,
                    icon: Icons.auto_awesome_rounded,
                    onPressed: _submit,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    return Row(
      children: [
        Icon(icon, size: 18.0, color: colors.secondary),
        SizedBox(width: spacing.xs),
        Expanded(
          child: Text(
            title,
            style: typography.titleSmall.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: spacing.xs),
          trailing!,
        ],
      ],
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelected();
      },
      borderRadius: BorderRadius.circular(radii.full),
      child: AnimatedContainer(
        duration: AppTokens.durations.quick,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.secondaryContainer : colors.surface,
          borderRadius: BorderRadius.circular(radii.full),
          border: Border.all(
            color: isSelected ? colors.secondary : colors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16.0,
                color: isSelected ? colors.secondary : colors.textSecondary,
              ),
              SizedBox(width: spacing.xs),
            ],
            Text(
              label,
              style: typography.labelMedium.copyWith(
                color: isSelected ? colors.secondary : colors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
