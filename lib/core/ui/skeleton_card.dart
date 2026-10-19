import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lunchbox_buddy/core/ui/ticket_clipper.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

/// Skeleton loader shaped like a lunch ticket, displayed while suggestions are being computed
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.notchY = 88.0});

  final double notchY;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final cardContent = ClipPath(
      clipper: PerforatedTicketClipper(
        notchY: notchY,
        borderRadius: radii.card,
        notchRadius: 12.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radii.card),
          border: Border.all(color: colors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: colors.buttonShadow.withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header skeleton
            Container(
              height: notchY,
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.md,
              ),
              color: colors.surfaceSubtle.withValues(alpha: 0.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SkeletonBox(width: 80, height: 24, borderRadius: radii.full),
                  _SkeletonBox(width: 70, height: 24, borderRadius: radii.full),
                ],
              ),
            ),

            // Perforated dashed divider
            CustomPaint(
              size: const Size(double.infinity, 1.5),
              painter: DashedSeparatorPainter(
                color: colors.border,
                dashWidth: 6,
                dashSpace: 4,
              ),
            ),

            // Content skeleton
            Padding(
              padding: EdgeInsetsDirectional.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title line 1
                  _SkeletonBox(
                    width: double.infinity,
                    height: 22,
                    borderRadius: radii.sm,
                  ),
                  SizedBox(height: spacing.sm),
                  // Title line 2
                  _SkeletonBox(width: 180, height: 22, borderRadius: radii.sm),
                  SizedBox(height: spacing.lg),

                  // Reason banner skeleton
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.all(spacing.md),
                    decoration: BoxDecoration(
                      color: colors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(radii.md),
                    ),
                    child: Row(
                      children: [
                        _SkeletonBox(
                          width: 20,
                          height: 20,
                          borderRadius: radii.full,
                        ),
                        SizedBox(width: spacing.sm),
                        Expanded(
                          child: _SkeletonBox(
                            width: double.infinity,
                            height: 16,
                            borderRadius: radii.xs,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing.lg),

                  // Tag chips row skeleton
                  Row(
                    children: [
                      _SkeletonBox(
                        width: 75,
                        height: 28,
                        borderRadius: radii.full,
                      ),
                      SizedBox(width: spacing.sm),
                      _SkeletonBox(
                        width: 85,
                        height: 28,
                        borderRadius: radii.full,
                      ),
                      SizedBox(width: spacing.sm),
                      _SkeletonBox(
                        width: 65,
                        height: 28,
                        borderRadius: radii.full,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.xl),

                  // Action button skeleton
                  _SkeletonBox(
                    width: double.infinity,
                    height: 48,
                    borderRadius: radii.md,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (reduceMotion) {
      return cardContent;
    }

    return cardContent.animate().shimmer(
      duration: 1200.ms,
      color: colors.surfaceSubtle.withValues(alpha: 0.8),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.borderSubtle,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
