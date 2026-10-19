import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/saved_recipes_notifier.dart';

/// Dynamic button with smooth width and content morphing across states:
/// Unsaved ("حفظ الوصفة") -> Saving ("جاري الحفظ...") -> Saved ("تم الحفظ ✓")
class DynamicSaveButton extends ConsumerStatefulWidget {
  const DynamicSaveButton({super.key, required this.recipeId, this.onChanged});

  final String recipeId;
  final ValueChanged<bool>? onChanged;

  @override
  ConsumerState<DynamicSaveButton> createState() => _DynamicSaveButtonState();
}

class _DynamicSaveButtonState extends ConsumerState<DynamicSaveButton> {
  bool _isSaving = false;

  Future<void> _handlePress(bool currentlySaved) async {
    try {
      unawaited(HapticFeedback.lightImpact());
    } catch (_) {}

    if (!currentlySaved) {
      setState(() => _isSaving = true);
      // Brief animated feedback delay
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      await ref
          .read(savedRecipeIdsProvider.notifier)
          .toggleSave(widget.recipeId);
      if (!mounted) return;
      setState(() => _isSaving = false);
      widget.onChanged?.call(true);
    } else {
      // Toggle back to unsaved
      await ref
          .read(savedRecipeIdsProvider.notifier)
          .toggleSave(widget.recipeId);
      widget.onChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final isSaved = ref.watch(
      savedRecipeIdsProvider.select(
        (async) => async.asData?.value.contains(widget.recipeId) ?? false,
      ),
    );

    // Dynamic width & content per state
    final double buttonWidth;
    final Color backgroundColor;
    final Color borderColor;
    final Color contentColor;
    final Widget content;

    if (_isSaving) {
      buttonWidth = 175.0;
      backgroundColor = colors.secondaryContainer;
      borderColor = colors.secondary.withValues(alpha: 0.4);
      contentColor = colors.secondary;
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 14.0,
            height: 14.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(colors.secondary),
            ),
          ),
          SizedBox(width: spacing.sm),
          Text(
            l10n.dynamicSavingAction,
            style: typography.labelMedium.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else if (isSaved) {
      buttonWidth = 150.0;
      backgroundColor = colors.secondary;
      borderColor = colors.secondary;
      contentColor = colors.onSecondary;
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 16.0, color: contentColor),
          SizedBox(width: spacing.xs),
          Text(
            l10n.dynamicSavedAction,
            style: typography.labelMedium.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      buttonWidth = 165.0;
      backgroundColor = colors.surface;
      borderColor = colors.border;
      contentColor = colors.textPrimary;
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 16.0, color: contentColor),
          SizedBox(width: spacing.xs),
          Text(
            l10n.dynamicSaveAction,
            style: typography.labelMedium.copyWith(
              color: contentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    final safeContent = Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.sm),
      child: FittedBox(fit: BoxFit.scaleDown, child: content),
    );

    return Semantics(
      button: true,
      label: isSaved ? l10n.unsaveRecipeTooltip : l10n.saveRecipeTooltip,
      child: AnimatedContainer(
        duration: AppTokens.durations.standard,
        curve: AppTokens.curves.easeOut,
        width: buttonWidth,
        height: AppTokens.touchTargets.min,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radii.card),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: colors.buttonShadow.withValues(alpha: 0.05),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radii.card),
            onTap: _isSaving ? null : () => _handlePress(isSaved),
            child: Center(
              child: AnimatedSwitcher(
                duration: AppTokens.durations.quick,
                child: KeyedSubtree(
                  key: ValueKey('save_btn_${_isSaving}_$isSaved'),
                  child: safeContent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
