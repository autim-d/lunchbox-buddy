import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

/// Hold-to-confirm button component:
/// User must press and hold down while the button fills with an animated progress.
/// Releasing early cancels the action. Completing the hold triggers confirmation and haptics.
class HoldButton extends StatefulWidget {
  const HoldButton({
    super.key,
    required this.idleLabel,
    required this.holdingLabel,
    required this.onConfirmed,
    this.duration = const Duration(milliseconds: 1400),
    this.icon = Icons.delete_outline_rounded,
  });

  final String idleLabel;
  final String holdingLabel;
  final VoidCallback onConfirmed;
  final Duration duration;
  final IconData icon;

  @override
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isHolding = false;
  bool _confirmedTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _confirmedTriggered = true;
          HapticFeedback.heavyImpact();
          widget.onConfirmed();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _confirmedTriggered = false;
    setState(() => _isHolding = true);
    HapticFeedback.selectionClick();
    _controller.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!_confirmedTriggered) {
      _controller.reverse();
    } else {
      _controller.reset();
    }
    if (mounted) {
      setState(() => _isHolding = false);
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (!_confirmedTriggered) {
      _controller.reverse();
    } else {
      _controller.reset();
    }
    if (mounted) {
      setState(() => _isHolding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const radii = AppTokens.radii;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    final baseBorderColor = colors.error.withValues(alpha: 0.3);
    final fillFillColor = colors.error.withValues(alpha: 0.18);

    return Semantics(
      button: true,
      label: _isHolding ? widget.holdingLabel : widget.idleLabel,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: AppTokens.touchTargets.min,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(radii.card),
            border: Border.all(color: baseBorderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Animated progress fill layer expanding along directionality
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: _controller.value,
                    child: Container(color: fillFillColor),
                  );
                },
              ),

              // Button content
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.md,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, color: colors.error, size: 20.0),
                      SizedBox(width: spacing.sm),
                      Text(
                        _isHolding ? widget.holdingLabel : widget.idleLabel,
                        style: typography.labelMedium.copyWith(
                          color: colors.error,
                          fontWeight: FontWeight.bold,
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
