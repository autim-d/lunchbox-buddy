import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';
import 'package:lunchbox_buddy/features/suggest/domain/ai_parsed_request.dart';
import 'package:lunchbox_buddy/features/suggest/domain/ai_request_parser.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/voice_input_service.dart';

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
  final Set<String> _excludedIngredientIds = {};
  final List<String> _unresolvedIngredients = [];
  String _ingredientSearchQuery = '';
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _ingredientSearchController =
      TextEditingController();

  bool _isListening = false;
  bool _isParsing = false;
  AiParsedRequest? _parsedRequest;

  @override
  void dispose() {
    _noteController.dispose();
    _ingredientSearchController.dispose();
    super.dispose();
  }

  Future<void> _toggleVoiceRecording() async {
    final voiceService = ref.read(voiceInputServiceProvider);

    if (_isListening) {
      await voiceService.stopListening();
      if (!mounted) return;
      setState(() => _isListening = false);
      if (_noteController.text.trim().isNotEmpty) {
        await _parseInputText(_noteController.text.trim());
      }
    } else {
      final started = await voiceService.startListening(
        onResult: (words) {
          if (!mounted) return;
          setState(() {
            _noteController.text = words;
          });
        },
        onListeningComplete: () {
          if (!mounted) return;
          setState(() => _isListening = false);
          if (_noteController.text.trim().isNotEmpty) {
            _parseInputText(_noteController.text.trim());
          }
        },
      );

      if (mounted) {
        setState(() => _isListening = started);
      }
    }
  }

  Future<void> _parseInputText(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _isParsing = true;
    });

    final parser = ref.read(aiRequestParserProvider);
    final result = await parser.parseRequest(rawText: text.trim());

    if (!mounted) return;

    setState(() {
      _isParsing = false;
      result.when(
        success: (parsed) {
          _parsedRequest = parsed;
          if (parsed.mealType.isNotEmpty) {
            _mealType = parsed.mealType;
          }
          if (parsed.maxMinutes != null && parsed.maxMinutes! > 0) {
            _maxMinutes = parsed.maxMinutes!;
          }
          _moodTags.addAll(parsed.moodTags);
          _selectedIngredientIds.addAll(parsed.availableIngredientIds);
          _excludedIngredientIds.addAll(parsed.excludedIngredientIds);
          _unresolvedIngredients.clear();
          _unresolvedIngredients.addAll(parsed.unresolvedIngredients);
          HapticFeedback.lightImpact();
        },
        error: (failure) {
          debugPrint('Request parsing error (silent fallback): $failure');
        },
      );
    });
  }

  void _submit() {
    final allKids = ref.read(kidsListNotifierProvider).asData?.value ?? [];
    final selectedIds = ref.read(selectedKidIdsProvider);

    final selectedKids = allKids
        .where((k) => selectedIds.contains(k.id))
        .toList();

    // Fallback if none selected: take all kids
    final baseKids = selectedKids.isNotEmpty ? selectedKids : allKids;

    // Apply any excluded ingredients to kids' dislikes so Scorer factors them in
    final effectiveKids = baseKids.map((k) {
      final combined = {...k.dislikes, ..._excludedIngredientIds}.toList();
      return k.copyWith(dislikes: combined);
    }).toList();

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

                    // Section 5: Notes & Voice Input Row
                    _SectionHeader(
                      title: l10n.notesFieldLabel,
                      icon: Icons.edit_note_rounded,
                      trailing: _noteController.text.trim().isNotEmpty
                          ? TextButton.icon(
                              onPressed: _isParsing
                                  ? null
                                  : () => _parseInputText(
                                      _noteController.text.trim(),
                                    ),
                              icon: const Icon(
                                Icons.auto_awesome_rounded,
                                size: 14.0,
                              ),
                              label: Text(
                                l10n.parseVoicePromptAction,
                                style: typography.labelSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(height: spacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _noteController,
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (text) => _parseInputText(text),
                            decoration: InputDecoration(
                              hintText: l10n.notesFieldPlaceholder,
                              filled: true,
                              fillColor: colors.surface,
                              contentPadding: EdgeInsetsDirectional.all(
                                spacing.md,
                              ),
                              suffixIcon: _noteController.text.trim().isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear_rounded,
                                        size: 18.0,
                                      ),
                                      onPressed: () {
                                        _noteController.clear();
                                        setState(() {});
                                      },
                                    )
                                  : null,
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
                        // Active Mic Button with listening indicator
                        Semantics(
                          button: true,
                          label: _isListening
                              ? l10n.listeningVoiceTooltip
                              : l10n.startVoiceTooltip,
                          child: InkWell(
                            onTap: _toggleVoiceRecording,
                            borderRadius: BorderRadius.circular(radii.card),
                            child: AnimatedContainer(
                              duration: AppTokens.durations.quick,
                              width: AppTokens.touchTargets.min,
                              height: AppTokens.touchTargets.min,
                              decoration: BoxDecoration(
                                color: _isListening
                                    ? colors.accentContainer
                                    : colors.surface,
                                borderRadius: BorderRadius.circular(radii.card),
                                border: Border.all(
                                  color: _isListening
                                      ? colors.accent
                                      : colors.border,
                                  width: _isListening ? 2.0 : 1.0,
                                ),
                                boxShadow: _isListening
                                    ? [
                                        BoxShadow(
                                          color: colors.accent.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                _isListening
                                    ? Icons.mic_rounded
                                    : Icons.mic_none_rounded,
                                color: _isListening
                                    ? colors.accent
                                    : colors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // AI Parsing indicator
                    if (_isParsing) ...[
                      SizedBox(height: spacing.sm),
                      LinearProgressIndicator(
                        backgroundColor: colors.secondaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        color: colors.secondary,
                        borderRadius: BorderRadius.circular(radii.full),
                      ),
                    ],

                    // Parsed Editable Chips Section
                    if (_parsedRequest != null) ...[
                      SizedBox(height: spacing.md),
                      _buildParsedChipsSection(
                        ingredientsAsync.asData?.value ?? const [],
                      ),
                    ],

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

  Widget _buildParsedChipsSection(List<Ingredient> allIngredients) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final ingredientMap = {
      for (final ing in allIngredients) ing.id: ing.nameAr,
    };

    return Container(
      padding: EdgeInsetsDirectional.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.secondaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(radii.card),
        border: Border.all(
          color: colors.secondary.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 16.0,
                color: colors.secondary,
              ),
              SizedBox(width: spacing.xs),
              Expanded(
                child: Text(
                  l10n.parsedChipsHeader,
                  style: typography.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.secondary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 16.0),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _parsedRequest = null;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.xs,
            runSpacing: spacing.xs,
            children: [
              // Meal type
              Chip(
                avatar: const Icon(Icons.restaurant_rounded, size: 14.0),
                label: Text(_mealType),
                backgroundColor: colors.surface,
                deleteIcon: const Icon(Icons.clear_rounded, size: 14.0),
                onDeleted: () => setState(() => _mealType = 'lunchbox'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radii.full),
                  side: BorderSide(color: colors.border),
                ),
              ),
              // Max minutes
              Chip(
                avatar: const Icon(Icons.schedule_rounded, size: 14.0),
                label: Text('$_maxMinutes min'),
                backgroundColor: colors.surface,
                deleteIcon: const Icon(Icons.clear_rounded, size: 14.0),
                onDeleted: () => setState(() => _maxMinutes = 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radii.full),
                  side: BorderSide(color: colors.border),
                ),
              ),
              // Mood tags
              for (final mood in _moodTags)
                Chip(
                  avatar: const Icon(Icons.mood_rounded, size: 14.0),
                  label: Text(mood),
                  backgroundColor: colors.surface,
                  deleteIcon: const Icon(Icons.clear_rounded, size: 14.0),
                  onDeleted: () => setState(() => _moodTags.remove(mood)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radii.full),
                    side: BorderSide(color: colors.border),
                  ),
                ),
              // Selected on-hand ingredients
              for (final ingId in _selectedIngredientIds)
                Chip(
                  avatar: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 14.0,
                  ),
                  label: Text(ingredientMap[ingId] ?? ingId),
                  backgroundColor: colors.surface,
                  deleteIcon: const Icon(Icons.clear_rounded, size: 14.0),
                  onDeleted: () =>
                      setState(() => _selectedIngredientIds.remove(ingId)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radii.full),
                    side: BorderSide(color: colors.secondary),
                  ),
                ),
              // Excluded ingredients
              for (final exclId in _excludedIngredientIds)
                Chip(
                  avatar: Icon(
                    Icons.block_rounded,
                    size: 14.0,
                    color: colors.error,
                  ),
                  label: Text('بدون ${ingredientMap[exclId] ?? exclId}'),
                  backgroundColor: colors.surface,
                  deleteIcon: const Icon(Icons.clear_rounded, size: 14.0),
                  onDeleted: () =>
                      setState(() => _excludedIngredientIds.remove(exclId)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radii.full),
                    side: BorderSide(
                      color: colors.error.withValues(alpha: 0.5),
                    ),
                  ),
                ),
            ],
          ),
          if (_unresolvedIngredients.isNotEmpty) ...[
            SizedBox(height: spacing.sm),
            Row(
              children: [
                Icon(
                  Icons.help_outline_rounded,
                  size: 14.0,
                  color: colors.accent,
                ),
                SizedBox(width: spacing.xs),
                Text(
                  l10n.unresolvedItemsWarning,
                  style: typography.bodySmall.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.xs),
            Wrap(
              spacing: spacing.xs,
              runSpacing: spacing.xs,
              children: [
                for (final item in _unresolvedIngredients)
                  Chip(
                    label: Text(item),
                    backgroundColor: colors.surface,
                    deleteIcon: const Icon(Icons.clear_rounded, size: 14.0),
                    onDeleted: () =>
                        setState(() => _unresolvedIngredients.remove(item)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radii.full),
                      side: BorderSide(
                        color: colors.accent.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
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
        if (trailing != null) ...[SizedBox(width: spacing.xs), trailing!],
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
