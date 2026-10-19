import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/app/locale_provider.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/kid_avatar_picker.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';

/// Placeholder Home screen for Lunchbox Buddy (لانش بوكس بادي)
/// Strictly RTL-first, EdgeInsetsDirectional only, zero hardcoded strings/colors.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;
    final currentLocale = ref.watch(appLocaleProvider);
    final isArabic = currentLocale.languageCode == 'ar';

    final kidsAsync = ref.watch(kidsListNotifierProvider);
    final activeKidId = ref.watch(activeKidIdProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: typography.titleLarge.copyWith(color: colors.textPrimary),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: spacing.md),
            child: ActionChip(
              avatar: Icon(
                Icons.language_rounded,
                size: 18.0,
                color: colors.secondary,
              ),
              label: Text(
                isArabic ? l10n.english : l10n.arabic,
                style: typography.labelMedium.copyWith(color: colors.secondary),
              ),
              backgroundColor: colors.secondaryContainer,
              side: BorderSide(color: colors.secondary.withValues(alpha: 0.2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radii.full),
              ),
              onPressed: () {
                ref.read(appLocaleProvider.notifier).toggleLocale();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Directionality & Locale Status Badge
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(radii.sm),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_textdirection_r_to_l_rounded,
                      size: 20.0,
                      color: colors.textSecondary,
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Text(
                        l10n.layoutDirectionLabel,
                        style: typography.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.lg),

              // Header & Subtitle
              Text(
                l10n.appTitle,
                style: typography.displayMedium.copyWith(
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: spacing.xs),
              Text(
                l10n.appSubtitle,
                style: typography.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: spacing.lg),

              // Registered Kids Selection Row
              kidsAsync.when(
                data: (kids) {
                  if (kids.isEmpty) return const SizedBox.shrink();

                  return Container(
                    padding: EdgeInsetsDirectional.all(spacing.md),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(radii.card),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.myKidsSectionTitle,
                              style: typography.labelLarge,
                            ),
                            TextButton.icon(
                              onPressed: () => context.push('/kids'),
                              icon: Icon(
                                Icons.tune_rounded,
                                size: 16.0,
                                color: colors.secondary,
                              ),
                              label: Text(
                                l10n.kidsManagementTitle,
                                style: typography.labelMedium.copyWith(
                                  color: colors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.sm),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: kids.map((kid) {
                              final isSelected = kid.id == activeKidId;
                              final avatarId =
                                  (kid.notes != null && kid.notes!.isNotEmpty)
                                  ? kid.notes!
                                  : 'avatar_chef';

                              return Padding(
                                padding: EdgeInsetsDirectional.only(
                                  end: spacing.sm,
                                ),
                                child: ChoiceChip(
                                  avatar: KidAvatarBadge(
                                    avatarId: avatarId,
                                    size: 24.0,
                                  ),
                                  label: Text(kid.name),
                                  selected: isSelected,
                                  selectedColor: colors.secondaryContainer,
                                  backgroundColor: colors.surfaceSubtle,
                                  onSelected: (selected) {
                                    if (selected) {
                                      ref
                                          .read(activeKidIdProvider.notifier)
                                          .selectKid(kid.id);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              SizedBox(height: spacing.lg),

              // Tactile Primary Action CTA Button ("اقترحي لي وجبة")
              AppButton(
                label: l10n.suggestMealButton,
                icon: Icons.lunch_dining_rounded,
                onPressed: () {
                  // Phase 3 suggest flow
                },
              ),
              SizedBox(height: spacing.xxl),

              // Today's Suggestions Card Placeholder
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(radii.card),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: colors.buttonShadow.withValues(alpha: 0.06),
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: EdgeInsetsDirectional.all(spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.all(spacing.sm),
                          decoration: BoxDecoration(
                            color: colors.accentContainer,
                            borderRadius: BorderRadius.circular(radii.sm),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: colors.accent,
                            size: 20.0,
                          ),
                        ),
                        SizedBox(width: spacing.md),
                        Expanded(
                          child: Text(
                            l10n.homePlaceholderTitle,
                            style: typography.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.sm),
                    Text(
                      l10n.homePlaceholderDescription,
                      style: typography.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: spacing.lg),

                    // Sample meal item 1
                    const _MealIdeaRow(
                      titleKey: 1,
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    SizedBox(height: spacing.sm),

                    // Sample meal item 2
                    const _MealIdeaRow(
                      titleKey: 2,
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    SizedBox(height: spacing.sm),

                    // Sample meal item 3
                    const _MealIdeaRow(
                      titleKey: 3,
                      icon: Icons.check_circle_outline_rounded,
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.xl),

              // Navigation button to Kids Management
              OutlinedButton.icon(
                onPressed: () {
                  context.push('/kids');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(
                    double.infinity,
                    AppTokens.touchTargets.min,
                  ),
                  side: BorderSide(color: colors.secondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radii.card),
                  ),
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: spacing.lg,
                  ),
                ),
                icon: Icon(Icons.child_care_rounded, color: colors.secondary),
                label: Text(
                  l10n.kidsManagementTitle,
                  style: typography.labelLarge.copyWith(
                    color: colors.secondary,
                  ),
                ),
              ),
              SizedBox(height: spacing.md),

              // Button to view debug recipes stored in local database
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/debug-recipes');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                    double.infinity,
                    AppTokens.touchTargets.min,
                  ),
                  backgroundColor: colors.secondaryContainer,
                  foregroundColor: colors.secondary,
                  elevation: 0,
                  side: BorderSide(
                    color: colors.secondary.withValues(alpha: 0.2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radii.card),
                  ),
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: spacing.lg,
                  ),
                ),
                icon: Icon(Icons.menu_book_rounded, color: colors.secondary),
                label: Text(
                  l10n.viewDebugRecipes,
                  style: typography.labelLarge.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.bold,
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

class _MealIdeaRow extends StatelessWidget {
  const _MealIdeaRow({required this.titleKey, required this.icon});

  final int titleKey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;
    final l10n = context.l10n;

    final title = switch (titleKey) {
      1 => l10n.suggestIdeaOne,
      2 => l10n.suggestIdeaTwo,
      _ => l10n.suggestIdeaThree,
    };

    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: BorderRadius.circular(AppTokens.radii.sm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.0, color: colors.secondary),
          SizedBox(width: spacing.sm),
          Expanded(child: Text(title, style: typography.bodyMedium)),
        ],
      ),
    );
  }
}
