import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/cook/presentation/cook_timer_notifier.dart';
import 'package:lunchbox_buddy/features/cook/presentation/widgets/cook_celebration_view.dart';
import 'package:lunchbox_buddy/features/cook/presentation/widgets/exit_cook_dialog.dart';
import 'package:lunchbox_buddy/features/cook/presentation/widgets/step_page.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/saved_recipes_notifier.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Cook Mode Screen designed for mothers cooking with wet/greasy hands:
/// - Screen stays awake via WakelockPlus
/// - 24sp+ high-contrast step instructions (one step per page)
/// - Integrated step duration detection with background timers
/// - Big greasy-finger friendly Next / Prev buttons
/// - Exit confirmation & celebration animation upon completion
class CookModeScreen extends ConsumerStatefulWidget {
  const CookModeScreen({super.key, required this.recipeId, this.initialRecipe});

  final String recipeId;
  final Recipe? initialRecipe;

  @override
  ConsumerState<CookModeScreen> createState() => _CookModeScreenState();
}

class _CookModeScreenState extends ConsumerState<CookModeScreen> {
  late final PageController _pageController;
  int _currentStep = 0;
  bool _isFinished = false;
  bool _timersInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _enableWakelock();
  }

  void _enableWakelock() {
    try {
      WakelockPlus.enable();
    } catch (_) {}
  }

  void _disableWakelock() {
    try {
      WakelockPlus.disable();
    } catch (_) {}
  }

  @override
  void dispose() {
    _pageController.dispose();
    _disableWakelock();
    super.dispose();
  }

  Future<void> _handleExit() async {
    final confirmed = await ExitCookConfirmationDialog.show(context);
    if (confirmed && mounted) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        try {
          context.pop();
        } catch (_) {}
      }
    }
  }

  void _goToStep(int index, int totalSteps) {
    if (index < 0 || index >= totalSteps) return;
    HapticFeedback.lightImpact();
    _pageController.animateToPage(
      index,
      duration: AppTokens.durations.relaxed,
      curve: AppTokens.curves.easeInOut,
    );
  }

  void _finishCooking() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final recipe =
        widget.initialRecipe ??
        ref.watch(recipeByIdProvider(widget.recipeId)).asData?.value;

    if (recipe == null) {
      final asyncRecipe = ref.watch(recipeByIdProvider(widget.recipeId));
      if (asyncRecipe.isLoading) {
        return Scaffold(
          backgroundColor: colors.background,
          body: const Center(child: CircularProgressIndicator.adaptive()),
        );
      }
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Text(
            l10n.emptyResultsTitle,
            style: typography.titleMedium.copyWith(color: colors.textPrimary),
          ),
        ),
      );
    }

    if (_isFinished) {
      return CookCelebrationView(recipe: recipe);
    }

    // Initialize timers for all steps once
    if (!_timersInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(cookTimersNotifierProvider.notifier).initSteps(recipe.steps);
      });
      _timersInitialized = true;
    }

    final timersMap = ref.watch(cookTimersNotifierProvider);
    final totalSteps = recipe.steps.length;
    final isFirstStep = _currentStep == 0;
    final isLastStep = _currentStep == totalSteps - 1;
    final progress = totalSteps > 0 ? (_currentStep + 1) / totalSteps : 1.0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleExit();
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, size: 28.0),
            tooltip: l10n.exitCookModeTitle,
            onPressed: _handleExit,
          ),
          title: Column(
            children: [
              Text(
                recipe.title,
                style: typography.titleSmall.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                l10n.stepProgressLabel(_currentStep + 1, totalSteps),
                style: typography.labelSmall.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            // Screen awake badge indicator
            Padding(
              padding: EdgeInsetsDirectional.only(end: spacing.md),
              child: Tooltip(
                message: 'الشاشة لن تنطفئ أثناء الطهي',
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: spacing.sm,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: colors.secondaryContainer,
                    borderRadius: BorderRadius.circular(radii.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wb_sunny_rounded,
                        size: 14.0,
                        color: colors.secondary,
                      ),
                      SizedBox(width: spacing.xs),
                      Text(
                        'نشطة',
                        style: typography.labelSmall.copyWith(
                          color: colors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4.0,
              backgroundColor: colors.surfaceSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // PageView for Steps
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalSteps,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final stepText = recipe.steps[index];
                    final stepTimers = timersMap.values
                        .where((t) => t.stepIndex == index)
                        .toList();

                    return StepPage(
                      stepIndex: index,
                      totalSteps: totalSteps,
                      stepText: stepText,
                      timers: stepTimers,
                      onStartTimer: (timerId) {
                        ref
                            .read(cookTimersNotifierProvider.notifier)
                            .startTimer(timerId);
                      },
                      onPauseTimer: (timerId) {
                        ref
                            .read(cookTimersNotifierProvider.notifier)
                            .pauseTimer(timerId);
                      },
                      onResetTimer: (timerId) {
                        ref
                            .read(cookTimersNotifierProvider.notifier)
                            .resetTimer(timerId);
                      },
                    );
                  },
                ),
              ),

              // Bottom Big Buttons Bar for Wet/Greasy Hands (56dp height)
              Container(
                padding: EdgeInsetsDirectional.all(spacing.md),
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(top: BorderSide(color: colors.borderSubtle)),
                  boxShadow: [
                    BoxShadow(
                      color: colors.buttonShadow.withValues(alpha: 0.08),
                      offset: const Offset(0, -3),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Previous Step Button
                      if (!isFirstStep) ...[
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: AppTokens.touchTargets.primaryAction,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: colors.border,
                                  width: 2.0,
                                ),
                                foregroundColor: colors.textPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    radii.card,
                                  ),
                                ),
                              ),
                              onPressed: () =>
                                  _goToStep(_currentStep - 1, totalSteps),
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 24.0,
                              ),
                              label: Text(
                                l10n.prevStepButton,
                                style: typography.labelLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: spacing.md),
                      ],

                      // Next Step / Finish Button
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: AppTokens.touchTargets.primaryAction,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLastStep
                                  ? colors.secondary
                                  : colors.accent,
                              foregroundColor: colors.textInverse,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(radii.card),
                              ),
                            ),
                            onPressed: () {
                              if (isLastStep) {
                                _finishCooking();
                              } else {
                                _goToStep(_currentStep + 1, totalSteps);
                              }
                            },
                            icon: Icon(
                              isLastStep
                                  ? Icons.check_circle_rounded
                                  : Icons.arrow_back_rounded,
                              size: 26.0,
                            ),
                            label: Text(
                              isLastStep
                                  ? l10n.finishCookingButton
                                  : l10n.nextStepButton,
                              style: typography.titleSmall.copyWith(
                                color: colors.textInverse,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
