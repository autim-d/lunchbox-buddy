import 'package:flutter/material.dart';

/// Container that applies a subtle vertical fade gradient to the top and bottom
/// edges of a long scrollable child (e.g., ingredient lists or chip rows).
class ScrollFadeContainer extends StatelessWidget {
  const ScrollFadeContainer({
    super.key,
    required this.child,
    this.fadeHeight = 20.0,
    this.enabled = true,
  });

  final Widget child;
  final double fadeHeight;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return ShaderMask(
      shaderCallback: (Rect rect) {
        if (rect.height <= 0) {
          return const LinearGradient(colors: [Colors.black, Colors.black])
              .createShader(rect);
        }

        final topStop = (fadeHeight / rect.height).clamp(0.0, 0.4);
        final bottomStop = (1.0 - (fadeHeight / rect.height)).clamp(0.6, 1.0);

        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.0, topStop, bottomStop, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
