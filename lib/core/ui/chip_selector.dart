import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

class ChipItem {
  const ChipItem({required this.id, required this.label, this.icon});

  final String id;
  final String label;
  final IconData? icon;
}

/// Accessible, RTL-first chip group selector with 48dp+ touch targets
class ChipSelector extends StatelessWidget {
  const ChipSelector({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onChanged,
    this.isMultiSelect = true,
  });

  final List<ChipItem> items;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;
  final bool isMultiSelect;

  void _handleTap(String id) {
    HapticFeedback.selectionClick();
    if (isMultiSelect) {
      final updated = Set<String>.from(selectedIds);
      if (updated.contains(id)) {
        updated.remove(id);
      } else {
        updated.add(id);
      }
      onChanged(updated);
    } else {
      if (selectedIds.contains(id)) {
        onChanged({});
      } else {
        onChanged({id});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const radii = AppTokens.radii;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      children: items.map((item) {
        final isSelected = selectedIds.contains(item.id);

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: AppTokens.touchTargets.min,
            minWidth: AppTokens.touchTargets.min,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleTap(item.id),
              borderRadius: BorderRadius.circular(radii.full),
              child: AnimatedContainer(
                duration: AppTokens.durations.quick,
                curve: AppTokens.curves.easeOut,
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.secondaryContainer
                      : colors.surface,
                  borderRadius: BorderRadius.circular(radii.full),
                  border: Border.all(
                    color: isSelected ? colors.secondary : colors.border,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 18.0,
                        color: isSelected
                            ? colors.secondary
                            : colors.textSecondary,
                      ),
                      SizedBox(width: spacing.xs),
                    ],
                    if (isSelected) ...[
                      Icon(
                        Icons.check_rounded,
                        size: 16.0,
                        color: colors.secondary,
                      ),
                      SizedBox(width: spacing.xs),
                    ],
                    Text(
                      item.label,
                      style: typography.labelMedium.copyWith(
                        color: isSelected
                            ? colors.secondary
                            : colors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
