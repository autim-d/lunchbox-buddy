import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

enum AppButtonVariant { primary, secondary, outline }

/// Tactile button component implementing the kitchen-warm interaction study:
/// Upon tap/press, the face moves down 2-3px with a shrink in shadow and a light haptic tap.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.height,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final double? height;
  final bool isLoading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;
    const spacing = AppTokens.spacing;

    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final buttonHeight = widget.height ?? AppTokens.touchTargets.primaryAction;

    // Resolve color styles according to variant
    final (
      Color faceColor,
      Color textColor,
      Color borderColor,
      Color shadowColor,
    ) = switch (widget.variant) {
      AppButtonVariant.primary => (
        isEnabled ? colors.accent : colors.accent.withValues(alpha: 0.5),
        colors.onAccent,
        Colors.transparent,
        colors.buttonShadow,
      ),
      AppButtonVariant.secondary => (
        isEnabled ? colors.secondary : colors.secondary.withValues(alpha: 0.5),
        colors.onSecondary,
        Colors.transparent,
        colors.buttonShadow,
      ),
      AppButtonVariant.outline => (
        colors.surface,
        isEnabled
            ? colors.textPrimary
            : colors.textSecondary.withValues(alpha: 0.5),
        colors.border,
        colors.buttonShadow.withValues(alpha: 0.04),
      ),
    };

    const double maxDepression = 3.0;
    final currentOffset = _isPressed ? maxDepression : 0.0;
    final currentShadowBlur = _isPressed ? 1.0 : 6.0;
    final currentShadowOffset = _isPressed ? 1.0 : 4.0;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: isEnabled ? widget.onPressed : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, currentOffset, 0),
          height: buttonHeight,
          decoration: BoxDecoration(
            color: faceColor,
            borderRadius: BorderRadius.circular(radii.card),
            border: Border.all(color: borderColor),
            boxShadow: [
              if (isEnabled)
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(0, currentShadowOffset),
                  blurRadius: currentShadowBlur,
                ),
            ],
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.lg),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: textColor, size: 22.0),
                          SizedBox(width: spacing.sm),
                        ],
                        Flexible(
                          child: Text(
                            widget.label,
                            style: typography.labelLarge.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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
