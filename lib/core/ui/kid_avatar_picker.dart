import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

class AvatarItem {
  const AvatarItem({
    required this.id,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final String id;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
}

/// Curated set of friendly vector avatars for kids
final List<AvatarItem> kAvailableAvatars = [
  const AvatarItem(
    id: 'avatar_chef',
    icon: Icons.outdoor_grill_rounded,
    backgroundColor: Color(0xFFFDEEEA),
    iconColor: Color(0xFFD94A2B),
  ),
  const AvatarItem(
    id: 'avatar_star',
    icon: Icons.star_rounded,
    backgroundColor: Color(0xFFFEF3C7),
    iconColor: Color(0xFFD97706),
  ),
  const AvatarItem(
    id: 'avatar_rabbit',
    icon: Icons.cruelty_free_rounded,
    backgroundColor: Color(0xFFE8F3ED),
    iconColor: Color(0xFF2D6A4F),
  ),
  const AvatarItem(
    id: 'avatar_smile',
    icon: Icons.sentiment_satisfied_alt_rounded,
    backgroundColor: Color(0xFFE0F2FE),
    iconColor: Color(0xFF0284C7),
  ),
  const AvatarItem(
    id: 'avatar_heart',
    icon: Icons.favorite_rounded,
    backgroundColor: Color(0xFFFCE7F3),
    iconColor: Color(0xFFDB2777),
  ),
  const AvatarItem(
    id: 'avatar_apple',
    icon: Icons.lunch_dining_rounded,
    backgroundColor: Color(0xFFF3E8FF),
    iconColor: Color(0xFF7E22CE),
  ),
];

AvatarItem getAvatarById(String id) {
  return kAvailableAvatars.firstWhere(
    (a) => a.id == id,
    orElse: () => kAvailableAvatars.first,
  );
}

/// Standalone visual avatar renderer
class KidAvatarBadge extends StatelessWidget {
  const KidAvatarBadge({super.key, required this.avatarId, this.size = 48.0});

  final String avatarId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final avatar = getAvatarById(avatarId);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatar.backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: avatar.iconColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Icon(avatar.icon, size: size * 0.55, color: avatar.iconColor),
      ),
    );
  }
}

/// Illustrated KidAvatarPicker with 48dp+ touch targets and clear selection state
class KidAvatarPicker extends StatelessWidget {
  const KidAvatarPicker({
    super.key,
    required this.selectedAvatarId,
    required this.onSelected,
  });

  final String selectedAvatarId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const spacing = AppTokens.spacing;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: kAvailableAvatars.map((item) {
          final isSelected = item.id == selectedAvatarId;

          return Padding(
            padding: EdgeInsetsDirectional.only(end: spacing.md),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: item.id,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSelected(item.id);
                },
                child: AnimatedContainer(
                  duration: AppTokens.durations.quick,
                  curve: AppTokens.curves.easeOut,
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: item.backgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? item.iconColor
                          : item.iconColor.withValues(alpha: 0.2),
                      width: isSelected ? 3.0 : 1.5,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: item.iconColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Icon(item.icon, size: 28.0, color: item.iconColor),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
