import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

/// Custom clipper that clips the bottom edge of a container with a realistic
/// zig-zag serrated tear edge, like thermal receipt paper torn from a dispenser.
class ReceiptTornEdgeClipper extends CustomClipper<Path> {
  const ReceiptTornEdgeClipper({
    this.toothWidth = 10.0,
    this.toothHeight = 5.0,
  });

  final double toothWidth;
  final double toothHeight;

  @override
  Path getClip(Size size) {
    final path = Path();
    // Top-left
    path.moveTo(0, 0);
    // Top-right
    path.lineTo(size.width, 0);
    // Right edge down to before the teeth
    path.lineTo(size.width, size.height - toothHeight);

    // Bottom edge with zigzag teeth from right to left
    final teethCount = (size.width / toothWidth).ceil();
    final actualToothWidth = size.width / teethCount;

    for (int i = 0; i < teethCount; i++) {
      final currentX = size.width - (i * actualToothWidth);
      final midX = currentX - (actualToothWidth / 2);
      final nextX = currentX - actualToothWidth;

      // Tooth apex (points downward)
      path.lineTo(midX, size.height);
      // Tooth root
      path.lineTo(nextX, size.height - toothHeight);
    }

    // Left edge up to top-left
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant ReceiptTornEdgeClipper oldClipper) {
    return oldClipper.toothWidth != toothWidth ||
        oldClipper.toothHeight != toothHeight;
  }
}

/// A paper container that renders children on receipt-styled paper with a
/// serrated bottom tear edge and a printer feed entry animation.
class ReceiptPaperContainer extends StatefulWidget {
  const ReceiptPaperContainer({
    super.key,
    required this.child,
    this.isPrinting = false,
    this.onPrintComplete,
    this.toothHeight = 6.0,
  });

  final Widget child;
  final bool isPrinting;
  final VoidCallback? onPrintComplete;
  final double toothHeight;

  @override
  State<ReceiptPaperContainer> createState() => ReceiptPaperContainerState();
}

class ReceiptPaperContainerState extends State<ReceiptPaperContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _printController;
  late final Animation<double> _feedAnimation;
  int _lastHapticStep = -1;

  @override
  void initState() {
    super.initState();
    _printController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _feedAnimation = CurvedAnimation(
      parent: _printController,
      curve: Curves.easeOutCubic,
    );

    _printController.addListener(_onAnimationTick);

    if (widget.isPrinting) {
      _startPrinting();
    } else {
      _printController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ReceiptPaperContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPrinting && !oldWidget.isPrinting) {
      _startPrinting();
    }
  }

  void _onAnimationTick() {
    // Provide subtle rhythmic mechanical haptic feedback at intervals
    final progress = _printController.value;
    final currentStep = (progress * 5).floor();
    if (currentStep != _lastHapticStep && progress < 1.0) {
      _lastHapticStep = currentStep;
      HapticFeedback.selectionClick();
    }
  }

  void startPrinting() {
    _startPrinting();
  }

  void _startPrinting() {
    _lastHapticStep = -1;
    _printController.forward(from: 0.0).then((_) {
      HapticFeedback.lightImpact();
      widget.onPrintComplete?.call();
    });
  }

  @override
  void dispose() {
    _printController.removeListener(_onAnimationTick);
    _printController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;

    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    if (reduceMotion) {
      return _buildPaper(context, 1.0);
    }

    return AnimatedBuilder(
      animation: _feedAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thermal printer slot representation
            Center(
              child: Container(
                width: 140.0,
                height: 5.0,
                margin: EdgeInsetsDirectional.only(bottom: spacing.xs),
                decoration: BoxDecoration(
                  color: colors.border.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(radii.full),
                  boxShadow: [
                    BoxShadow(
                      color: colors.textPrimary.withValues(alpha: 0.08),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Expanding feed paper
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _feedAnimation.value,
                child: _buildPaper(context, _feedAnimation.value),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaper(BuildContext context, double printProgress) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;

    return ClipPath(
      clipper: ReceiptTornEdgeClipper(toothHeight: widget.toothHeight),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(radii.sm)),
          border: BorderDirectional(
            top: BorderSide(color: colors.borderSubtle),
            start: BorderSide(color: colors.borderSubtle),
            end: BorderSide(color: colors.borderSubtle),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.buttonShadow.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        padding: EdgeInsetsDirectional.only(
          start: spacing.md,
          end: spacing.md,
          top: spacing.lg,
          bottom: spacing.xl + widget.toothHeight,
        ),
        child: Opacity(
          opacity: printProgress.clamp(0.2, 1.0),
          child: widget.child,
        ),
      ),
    );
  }
}
