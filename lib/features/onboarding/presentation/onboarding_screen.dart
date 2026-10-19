import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/app/locale_provider.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/chip_selector.dart';
import 'package:lunchbox_buddy/core/ui/kid_avatar_picker.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kid_form_helpers.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';

/// 60-Second Onboarding Flow for Lunchbox Buddy (لانش بوكس بادي)
///
/// Steps:
/// 0: Welcome presentation
/// 1: Add first child form (name, birth month/year, pickiness, allergies, dislikes)
/// 2: Success state with option to add another child or proceed to Home.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  int _currentStep = 0;
  String _selectedAvatarId = 'avatar_chef';
  int _birthYear = DateTime.now().year - 6;
  int _birthMonth = 9; // September (school start)
  int _pickyLevel = 1;
  String _lunchboxType = 'none';

  Set<String> _selectedAllergies = {};
  Set<String> _selectedDislikes = {};

  String? _lastSavedChildName;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _resetFormForNextChild() {
    _nameController.clear();
    setState(() {
      _currentStep = 1;
      _selectedAvatarId = 'avatar_star';
      _birthYear = DateTime.now().year - 4;
      _birthMonth = 1;
      _pickyLevel = 1;
      _lunchboxType = 'none';
      _selectedAllergies = {};
      _selectedDislikes = {};
    });
  }

  Future<void> _submitChildForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final childName = _nameController.text.trim();
    final childId = 'kid_${DateTime.now().millisecondsSinceEpoch}';

    final birthDate = DateTime(_birthYear, _birthMonth, 1);

    final newKid = KidProfile(
      id: childId,
      name: childName,
      birthDate: birthDate,
      allergies: _selectedAllergies.toList(),
      dislikes: _selectedDislikes.toList(),
      likes: const [],
      pickyLevel: _pickyLevel,
      lunchboxType: _lunchboxType,
      notes: _selectedAvatarId, // Stores selected avatar ID
    );

    await ref.read(kidsListNotifierProvider.notifier).addKid(newKid);

    setState(() {
      _isSaving = false;
      _lastSavedChildName = childName;
      _currentStep = 2; // Success step
    });
  }

  List<ChipItem> _getAllergyChips(AppLocalizations l10n) =>
      KidFormHelpers.getAllergyChips(l10n);

  List<ChipItem> _getDislikeChips(AppLocalizations l10n) =>
      KidFormHelpers.getDislikeChips(l10n);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;
    final isArabic = ref.watch(appLocaleProvider).languageCode == 'ar';

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
                borderRadius: BorderRadius.circular(AppTokens.radii.full),
              ),
              onPressed: () {
                ref.read(appLocaleProvider.notifier).toggleLocale();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (_currentStep) {
          0 => _buildWelcomeStep(l10n, colors, spacing, typography),
          1 => _buildAddChildStep(l10n, colors, spacing, typography),
          _ => _buildSuccessStep(l10n, colors, spacing, typography),
        },
      ),
    );
  }

  Widget _buildWelcomeStep(
    AppLocalizations l10n,
    AppColors colors,
    AppSpacing spacing,
    AppTypography typography,
  ) {
    return Padding(
      padding: EdgeInsetsDirectional.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 104.0,
              height: 104.0,
              decoration: BoxDecoration(
                color: colors.accentContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.accent.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.lunch_dining_rounded,
                size: 52.0,
                color: colors.accent,
              ),
            ),
          ),
          SizedBox(height: spacing.xl),
          Text(
            l10n.welcomeTitle,
            style: typography.displayMedium.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.sm),
          Text(
            l10n.welcomeSubtitle,
            style: typography.bodyLarge.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.xxl),
          _FeaturePointRow(
            icon: Icons.timer_outlined,
            title: l10n.welcomeFeature1Title,
            subtitle: l10n.welcomeFeature1Subtitle,
            colors: colors,
            spacing: spacing,
            typography: typography,
          ),
          SizedBox(height: spacing.md),
          _FeaturePointRow(
            icon: Icons.shield_outlined,
            title: l10n.welcomeFeature2Title,
            subtitle: l10n.welcomeFeature2Subtitle,
            colors: colors,
            spacing: spacing,
            typography: typography,
          ),
          const Spacer(flex: 2),
          AppButton(
            label: l10n.onboardingButton,
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              setState(() => _currentStep = 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildStep(
    AppLocalizations l10n,
    AppColors colors,
    AppSpacing spacing,
    AppTypography typography,
  ) {
    final currentYear = DateTime.now().year;
    final years = List.generate(14, (i) => currentYear - i);
    final months = List.generate(12, (i) => i + 1);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.onboardingStepOneTitle,
              style: typography.displayMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.xs),
            Text(
              l10n.onboardingStepOneDescription,
              style: typography.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.xl),

            // Child Avatar Picker
            Text(l10n.avatarSectionTitle, style: typography.labelLarge),
            SizedBox(height: spacing.sm),
            KidAvatarPicker(
              selectedAvatarId: _selectedAvatarId,
              onSelected: (id) => setState(() => _selectedAvatarId = id),
            ),
            SizedBox(height: spacing.xl),

            // Child Name Input
            Text(l10n.childNameLabel, style: typography.labelLarge),
            SizedBox(height: spacing.xs),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: l10n.childNameHint,
                prefixIcon: Icon(
                  Icons.person_rounded,
                  color: colors.textSecondary,
                ),
                filled: true,
                fillColor: colors.surface,
                contentPadding: EdgeInsetsDirectional.all(spacing.md),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radii.card),
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radii.card),
                  borderSide: BorderSide(color: colors.border),
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return l10n.childNameRequired;
                }
                return null;
              },
            ),
            SizedBox(height: spacing.xl),

            // Birth Year & Month
            Text(l10n.birthDateLabel, style: typography.labelLarge),
            SizedBox(height: spacing.xs),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _birthYear,
                    decoration: InputDecoration(
                      labelText: l10n.birthYear,
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTokens.radii.card,
                        ),
                        borderSide: BorderSide(color: colors.border),
                      ),
                    ),
                    items: years.map((y) {
                      return DropdownMenuItem(value: y, child: Text('$y'));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _birthYear = val);
                    },
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _birthMonth,
                    decoration: InputDecoration(
                      labelText: l10n.birthMonth,
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTokens.radii.card,
                        ),
                        borderSide: BorderSide(color: colors.border),
                      ),
                    ),
                    items: months.map((m) {
                      return DropdownMenuItem(value: m, child: Text('$m'));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _birthMonth = val);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.xl),

            // Pickiness Level Slider/Cards
            Text(l10n.pickinessLabel, style: typography.labelLarge),
            SizedBox(height: spacing.xs),
            Container(
              padding: EdgeInsetsDirectional.all(spacing.md),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppTokens.radii.card),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  Slider(
                    value: _pickyLevel.toDouble(),
                    min: 0,
                    max: 3,
                    divisions: 3,
                    activeColor: colors.accent,
                    onChanged: (val) {
                      setState(() => _pickyLevel = val.round());
                    },
                  ),
                  Text(
                    switch (_pickyLevel) {
                      0 => l10n.pickyLevel0,
                      1 => l10n.pickyLevel1,
                      2 => l10n.pickyLevel2,
                      _ => l10n.pickyLevel3,
                    },
                    style: typography.labelLarge.copyWith(
                      color: colors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.xl),

            // Allergies
            Text(l10n.allergiesSectionTitle, style: typography.labelLarge),
            SizedBox(height: spacing.xs),
            ChipSelector(
              items: _getAllergyChips(l10n),
              selectedIds: _selectedAllergies,
              onChanged: (updated) {
                setState(() => _selectedAllergies = updated);
              },
            ),
            SizedBox(height: spacing.xl),

            // Dislikes
            Text(l10n.dislikesSectionTitle, style: typography.labelLarge),
            SizedBox(height: spacing.xs),
            ChipSelector(
              items: _getDislikeChips(l10n),
              selectedIds: _selectedDislikes,
              onChanged: (updated) {
                setState(() => _selectedDislikes = updated);
              },
            ),
            SizedBox(height: spacing.xl),

            // Lunchbox Type
            Text(l10n.lunchboxTypeLabel, style: typography.labelLarge),
            SizedBox(height: spacing.xs),
            ChipSelector(
              isMultiSelect: false,
              items: [
                ChipItem(
                  id: 'none',
                  label: l10n.lunchboxNone,
                  icon: Icons.check_box_outline_blank_rounded,
                ),
                ChipItem(
                  id: 'cold',
                  label: l10n.lunchboxCold,
                  icon: Icons.ac_unit_rounded,
                ),
                ChipItem(
                  id: 'hot',
                  label: l10n.lunchboxHot,
                  icon: Icons.whatshot_rounded,
                ),
              ],
              selectedIds: {_lunchboxType},
              onChanged: (updated) {
                if (updated.isNotEmpty) {
                  setState(() => _lunchboxType = updated.first);
                }
              },
            ),
            SizedBox(height: spacing.xxl),

            // Submit Button
            AppButton(
              label: l10n.saveAndContinue,
              isLoading: _isSaving,
              icon: Icons.check_circle_rounded,
              onPressed: _submitChildForm,
            ),
            SizedBox(height: spacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessStep(
    AppLocalizations l10n,
    AppColors colors,
    AppSpacing spacing,
    AppTypography typography,
  ) {
    final name = _lastSavedChildName ?? '';

    return Padding(
      padding: EdgeInsetsDirectional.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 96.0,
              height: 96.0,
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 52.0,
                color: colors.secondary,
              ),
            ),
          ),
          SizedBox(height: spacing.xl),
          Text(
            l10n.addChildSuccess(name),
            style: typography.displayMedium.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.sm),
          Text(
            l10n.welcomeSubtitle,
            style: typography.bodyMedium.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),

          // Option 1: Add another child
          AppButton(
            label: l10n.addAnotherChild,
            variant: AppButtonVariant.outline,
            icon: Icons.add_circle_outline_rounded,
            onPressed: _resetFormForNextChild,
          ),
          SizedBox(height: spacing.md),

          // Option 2: Finish and navigate to Home
          AppButton(
            label: l10n.finishAndGoHome,
            variant: AppButtonVariant.primary,
            icon: Icons.home_rounded,
            onPressed: () {
              context.go('/home');
            },
          ),
        ],
      ),
    );
  }
}

class _FeaturePointRow extends StatelessWidget {
  const _FeaturePointRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.spacing,
    required this.typography,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final AppColors colors;
  final AppSpacing spacing;
  final AppTypography typography;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radii.card),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(spacing.sm),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppTokens.radii.sm),
            ),
            child: Icon(icon, color: colors.secondary, size: 22.0),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: typography.titleSmall),
                Text(
                  subtitle,
                  style: typography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
