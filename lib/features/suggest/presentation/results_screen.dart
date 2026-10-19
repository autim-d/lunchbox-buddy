import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/recipe_card.dart';
import 'package:lunchbox_buddy/core/ui/skeleton_card.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_bottom_sheet.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';

/// Screen displaying 3 swipeable RecipeCards shaped like lunch tickets
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSimulatingDelay = true;

  @override
  void initState() {
    super.initState();
    // Simulate brief 450ms calculation delay so the mother sees the skeleton ticket loader
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() => _isSimulatingDelay = false);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  MealSuggestionRequest _resolveRequest() {
    final activeRequest = ref.read(currentSuggestionRequestProvider);
    if (activeRequest != null) return activeRequest;

    final allKids = ref.read(kidsListNotifierProvider).asData?.value ?? [];
    return MealSuggestionRequest(
      selectedKids: allKids,
      maxMinutes: 20,
      mealType: 'lunchbox',
      moodTags: const ['quick'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final request = _resolveRequest();
    final suggestionsAsync = ref.watch(mealSuggestionsProvider(request));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.resultsScreenTitle,
          style: typography.titleLarge.copyWith(color: colors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, color: colors.secondary),
            tooltip: l10n.adjustFiltersButton,
            onPressed: () => SuggestBottomSheet.show(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header description & Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      l10n.resultsScreenSubtitle,
                      style: typography.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  if (!_isSimulatingDelay &&
                      suggestionsAsync.hasValue &&
                      suggestionsAsync.asData!.value.isNotEmpty)
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
                        l10n.cardCounter(
                          _currentPage + 1,
                          suggestionsAsync.asData!.value.length,
                        ),
                        style: typography.labelSmall.copyWith(
                          color: colors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: spacing.md),

              // Main Swiping Content Area
              Expanded(
                child: _isSimulatingDelay
                    ? const Center(
                        child: SingleChildScrollView(child: SkeletonCard()),
                      )
                    : suggestionsAsync.when(
                        data: (recommendations) {
                          if (recommendations.isEmpty) {
                            return _EmptyStateView(
                              onAdjustFilters: () {
                                Navigator.of(context).pop();
                                SuggestBottomSheet.show(context);
                              },
                            );
                          }

                          return Column(
                            children: [
                              Expanded(
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: recommendations.length,
                                  onPageChanged: (index) {
                                    setState(() => _currentPage = index);
                                  },
                                  itemBuilder: (context, index) {
                                    final rec = recommendations[index];

                                    final cardWidget = Padding(
                                      padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: spacing.xs,
                                        vertical: spacing.sm,
                                      ),
                                      child: RecipeCard(
                                        recipe: rec.recipe,
                                        reasonKey: rec.reasonKey,
                                        score: rec.score,
                                        isScrollable: true,
                                        onTap: () {
                                          context.push(
                                            '/recipe/${rec.recipe.id}',
                                            extra: rec.recipe,
                                          );
                                        },
                                      ),
                                    );

                                    if (reduceMotion) {
                                      return cardWidget;
                                    }

                                    // Staggered entry animation: 150-300ms
                                    return cardWidget
                                        .animate(delay: (index * 75).ms)
                                        .fadeIn(
                                          duration: 250.ms,
                                          curve: Curves.easeOut,
                                        )
                                        .slideY(
                                          begin: 0.08,
                                          end: 0,
                                          duration: 250.ms,
                                          curve: Curves.easeOut,
                                        );
                                  },
                                ),
                              ),
                              SizedBox(height: spacing.md),

                              // Page Dots Indicator
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  recommendations.length,
                                  (index) {
                                    final isActive = _currentPage == index;
                                    return AnimatedContainer(
                                      duration: AppTokens.durations.quick,
                                      margin: EdgeInsetsDirectional.symmetric(
                                        horizontal: spacing.xs,
                                      ),
                                      width: isActive ? 24.0 : 8.0,
                                      height: 8.0,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? colors.accent
                                            : colors.border,
                                        borderRadius: BorderRadius.circular(
                                          radii.full,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: spacing.xs),
                            ],
                          );
                        },
                        loading: () => const Center(
                          child: SingleChildScrollView(child: SkeletonCard()),
                        ),
                        error: (error, _) => _ErrorStateView(
                          onRetry: () {
                            ref.invalidate(mealSuggestionsProvider(request));
                          },
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

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView({required this.onAdjustFilters});

  final VoidCallback onAdjustFilters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: colors.accentContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.soup_kitchen_outlined,
                size: 40.0,
                color: colors.accent,
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              l10n.emptyResultsTitle,
              style: typography.titleLarge.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              l10n.emptyResultsMessage,
              style: typography.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xl),
            AppButton(
              label: l10n.adjustFiltersButton,
              icon: Icons.tune_rounded,
              onPressed: onAdjustFilters,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorStateView extends StatelessWidget {
  const _ErrorStateView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: colors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40.0,
                color: colors.error,
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              l10n.errorResultsTitle,
              style: typography.titleLarge.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xl),
            AppButton(
              label: l10n.retryButton,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
