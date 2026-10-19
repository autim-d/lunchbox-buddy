import 'package:flutter/material.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

/// Clean, illustrated food header for recipe detail and result cards
/// Provides consistent category-themed visuals with smooth Hero transitions.
class RecipeCategoryIllustration extends StatelessWidget {
  const RecipeCategoryIllustration({
    super.key,
    required this.recipe,
    this.height = 180.0,
    this.borderRadius,
    this.enableHero = true,
    this.showHalalBadge = true,
  });

  final Recipe recipe;
  final double height;
  final BorderRadius? borderRadius;
  final bool enableHero;
  final bool showHalalBadge;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const radii = AppTokens.radii;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(radii.card);

    // Determine category theme based on tags or id
    final tags = recipe.tags.map((t) => t.toLowerCase()).toList();
    final isBreakfast = tags.any(
      (t) => t.contains('breakfast') || t.contains('فطور'),
    );
    final isDinner = tags.any(
      (t) => t.contains('dinner') || t.contains('عشاء'),
    );
    final isSnack = tags.any(
      (t) => t.contains('snack') || t.contains('سناك') || t.contains('sweet'),
    );
    final isLunchbox = tags.any(
      (t) => t.contains('lunchbox') || t.contains('لانش'),
    );

    final Color bgColor;
    final Color iconColor;
    final IconData primaryIcon;
    final IconData secondaryIcon;

    if (isBreakfast) {
      bgColor = const Color(0xFFFFF3E0); // Warm apricot
      iconColor = const Color(0xFFE65100);
      primaryIcon = Icons.wb_sunny_rounded;
      secondaryIcon = Icons.bakery_dining_rounded;
    } else if (isDinner) {
      bgColor = const Color(0xFFF3E5F5); // Soft lavender/charcoal
      iconColor = const Color(0xFF6A1B9A);
      primaryIcon = Icons.dinner_dining_rounded;
      secondaryIcon = Icons.soup_kitchen_rounded;
    } else if (isSnack) {
      bgColor = const Color(0xFFFFEBEE); // Soft strawberry
      iconColor = const Color(0xFFC2185B);
      primaryIcon = Icons.cookie_rounded;
      secondaryIcon = Icons.cake_rounded;
    } else if (isLunchbox) {
      bgColor = colors.secondaryContainer;
      iconColor = colors.secondary;
      primaryIcon = Icons.lunch_dining_rounded;
      secondaryIcon = Icons.eco_rounded;
    } else {
      bgColor = colors.accentContainer;
      iconColor = colors.accent;
      primaryIcon = Icons.restaurant_rounded;
      secondaryIcon = Icons.auto_awesome_rounded;
    }

    final illustrationContent = Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(color: bgColor, borderRadius: effectiveRadius),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background decorative ambient circles
          PositionedDirectional(
            end: -20,
            bottom: -20,
            child: Icon(
              secondaryIcon,
              size: height * 0.9,
              color: iconColor.withValues(alpha: 0.08),
            ),
          ),
          PositionedDirectional(
            start: -15,
            top: -15,
            child: Icon(
              primaryIcon,
              size: height * 0.7,
              color: iconColor.withValues(alpha: 0.07),
            ),
          ),

          // Center visual badge
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.buttonShadow.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(primaryIcon, size: height * 0.32, color: iconColor),
            ),
          ),

          // Halal & Safe corner tag
          if (showHalalBadge)
            PositionedDirectional(
              top: 12.0,
              start: 12.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(radii.full),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 14.0,
                      color: colors.secondary,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      'حلال 100%',
                      style: AppTokens.typography.labelSmall.copyWith(
                        color: colors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    if (!enableHero) return illustrationContent;

    return Hero(
      tag: 'recipe_hero_${recipe.id}',
      child: Material(color: Colors.transparent, child: illustrationContent),
    );
  }
}
