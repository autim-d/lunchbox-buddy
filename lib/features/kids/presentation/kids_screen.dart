import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/chip_selector.dart';
import 'package:lunchbox_buddy/core/ui/hold_button.dart';
import 'package:lunchbox_buddy/core/ui/kid_avatar_picker.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kid_form_helpers.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';

/// Kids management screen: lists all children, allows adding new children,
/// editing existing ones, and deleting with HoldButton & undo.
class KidsScreen extends ConsumerWidget {
  const KidsScreen({super.key});

  String _formatAge(DateTime birthDate, AppLocalizations l10n) {
    final now = DateTime.now();
    int months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    if (months < 0) months = 0;

    final years = months ~/ 12;
    if (years > 0) {
      return l10n.ageYearsMonths(years);
    } else {
      return l10n.ageMonthsOnly(months);
    }
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, KidProfile kid) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _EditKidBottomSheet(kid: kid);
      },
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return const _AddKidBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final kidsAsync = ref.watch(kidsListNotifierProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.kidsManagementTitle,
          style: typography.titleLarge.copyWith(color: colors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: kidsAsync.when(
          loading: () =>
              Center(child: CircularProgressIndicator(color: colors.accent)),
          error: (err, stack) =>
              Center(child: Text(err.toString(), style: typography.bodyMedium)),
          data: (kids) {
            if (kids.isEmpty) {
              return Padding(
                padding: EdgeInsetsDirectional.all(spacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: colors.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.child_care_rounded,
                        size: 40.0,
                        color: colors.secondary,
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    Text(
                      l10n.noKidsYet,
                      style: typography.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing.xl),
                    AppButton(
                      label: l10n.addNewChild,
                      icon: Icons.add_rounded,
                      onPressed: () => _showAddSheet(context, ref),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: EdgeInsetsDirectional.all(spacing.lg),
              children: [
                // Header info
                Text(
                  l10n.kidsManagementSubtitle,
                  style: typography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: spacing.lg),

                // List of child cards
                ...kids.map((kid) {
                  final avatarId = (kid.notes != null && kid.notes!.isNotEmpty)
                      ? kid.notes!
                      : 'avatar_chef';
                  final ageString = _formatAge(kid.birthDate, l10n);

                  return Container(
                    margin: EdgeInsetsDirectional.only(bottom: spacing.lg),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(radii.card),
                      border: Border.all(color: colors.border),
                      boxShadow: [
                        BoxShadow(
                          color: colors.buttonShadow.withValues(alpha: 0.05),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    padding: EdgeInsetsDirectional.all(spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            KidAvatarBadge(avatarId: avatarId, size: 52.0),
                            SizedBox(width: spacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kid.name,
                                    style: typography.titleLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ageString,
                                    style: typography.bodySmall.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: colors.secondary,
                              ),
                              tooltip: l10n.editChild,
                              onPressed: () =>
                                  _showEditSheet(context, ref, kid),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.md),

                        // Pickiness & Lunchbox type row
                        Wrap(
                          spacing: spacing.sm,
                          runSpacing: spacing.xs,
                          children: [
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: spacing.sm,
                                vertical: spacing.xs / 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.accentContainer,
                                borderRadius: BorderRadius.circular(radii.sm),
                              ),
                              child: Text(
                                switch (kid.pickyLevel) {
                                  0 => l10n.pickyLevel0,
                                  1 => l10n.pickyLevel1,
                                  2 => l10n.pickyLevel2,
                                  _ => l10n.pickyLevel3,
                                },
                                style: typography.labelMedium.copyWith(
                                  color: colors.accent,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: spacing.sm,
                                vertical: spacing.xs / 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(radii.sm),
                                border: Border.all(color: colors.borderSubtle),
                              ),
                              child: Text(
                                switch (kid.lunchboxType) {
                                  'cold' => l10n.lunchboxCold,
                                  'hot' => l10n.lunchboxHot,
                                  _ => l10n.lunchboxNone,
                                },
                                style: typography.labelMedium.copyWith(
                                  color: colors.textSecondary,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.md),

                        // Allergies chips
                        if (kid.allergies.isNotEmpty) ...[
                          Text(
                            l10n.allergiesSectionTitle,
                            style: typography.labelMedium,
                          ),
                          SizedBox(height: spacing.xs),
                          Wrap(
                            spacing: spacing.xs,
                            runSpacing: spacing.xs,
                            children: kid.allergies.map((allergy) {
                              return Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: spacing.sm,
                                  vertical: spacing.xs / 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.errorContainer,
                                  borderRadius: BorderRadius.circular(radii.sm),
                                ),
                                child: Text(
                                  KidFormHelpers.formatAllergyLabel(
                                    allergy,
                                    l10n,
                                  ),
                                  style: typography.labelMedium.copyWith(
                                    color: colors.error,
                                    fontSize: 12.0,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: spacing.md),
                        ],

                        // Dislikes chips
                        if (kid.dislikes.isNotEmpty) ...[
                          Text(
                            l10n.dislikesSectionTitle,
                            style: typography.labelMedium,
                          ),
                          SizedBox(height: spacing.xs),
                          Wrap(
                            spacing: spacing.xs,
                            runSpacing: spacing.xs,
                            children: kid.dislikes.map((dislike) {
                              return Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: spacing.sm,
                                  vertical: spacing.xs / 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(radii.sm),
                                ),
                                child: Text(
                                  KidFormHelpers.formatDislikeLabel(
                                    dislike,
                                    l10n,
                                  ),
                                  style: typography.labelMedium.copyWith(
                                    color: colors.secondary,
                                    fontSize: 12.0,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: spacing.md),
                        ],

                        // Hold to Delete Button with Undo Snackbar
                        HoldButton(
                          idleLabel: l10n.deleteChildHoldPrompt,
                          holdingLabel: l10n.deleteChildHolding,
                          onConfirmed: () async {
                            final deletedKid = kid;
                            await ref
                                .read(kidsListNotifierProvider.notifier)
                                .deleteKid(kid.id);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.childDeletedMessage(deletedKid.name),
                                  ),
                                  action: SnackBarAction(
                                    label: l10n.undoButton,
                                    onPressed: () {
                                      ref
                                          .read(
                                            kidsListNotifierProvider.notifier,
                                          )
                                          .restoreKid(deletedKid);
                                    },
                                  ),
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),

                SizedBox(height: spacing.md),

                // Add Child Button
                AppButton(
                  label: l10n.addNewChild,
                  icon: Icons.add_rounded,
                  variant: AppButtonVariant.outline,
                  onPressed: () => _showAddSheet(context, ref),
                ),
                SizedBox(height: spacing.xxl),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EditKidBottomSheet extends ConsumerStatefulWidget {
  const _EditKidBottomSheet({required this.kid});

  final KidProfile kid;

  @override
  ConsumerState<_EditKidBottomSheet> createState() =>
      _EditKidBottomSheetState();
}

class _EditKidBottomSheetState extends ConsumerState<_EditKidBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _avatarId;
  late int _birthYear;
  late int _birthMonth;
  late int _pickyLevel;
  late String _lunchboxType;
  late Set<String> _selectedAllergies;
  late Set<String> _selectedDislikes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.kid.name);
    _avatarId = (widget.kid.notes != null && widget.kid.notes!.isNotEmpty)
        ? widget.kid.notes!
        : 'avatar_chef';
    _birthYear = widget.kid.birthDate.year;
    _birthMonth = widget.kid.birthDate.month;
    _pickyLevel = widget.kid.pickyLevel;
    _lunchboxType = widget.kid.lunchboxType;
    _selectedAllergies = Set<String>.from(widget.kid.allergies);
    _selectedDislikes = Set<String>.from(widget.kid.dislikes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedKid = widget.kid.copyWith(
      name: _nameController.text.trim(),
      birthDate: DateTime(_birthYear, _birthMonth, 1),
      pickyLevel: _pickyLevel,
      lunchboxType: _lunchboxType,
      allergies: _selectedAllergies.toList(),
      dislikes: _selectedDislikes.toList(),
      notes: _avatarId,
    );

    await ref.read(kidsListNotifierProvider.notifier).updateKid(updatedKid);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final currentYear = DateTime.now().year;
    final years = List.generate(14, (i) => currentYear - i);
    final months = List.generate(12, (i) => i + 1);

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radii.cardLg)),
      ),
      padding: EdgeInsetsDirectional.only(
        start: spacing.lg,
        end: spacing.lg,
        top: spacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + spacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.editChild, style: typography.titleLarge),
              SizedBox(height: spacing.xs),
              Text(
                l10n.editChildSubtitle,
                style: typography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              SizedBox(height: spacing.lg),

              // Avatar picker
              Text(l10n.avatarSectionTitle, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
              KidAvatarPicker(
                selectedAvatarId: _avatarId,
                onSelected: (id) => setState(() => _avatarId = id),
              ),
              SizedBox(height: spacing.lg),

              // Name
              Text(l10n.childNameLabel, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radii.card),
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
              SizedBox(height: spacing.lg),

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
                          borderRadius: BorderRadius.circular(radii.card),
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
                          borderRadius: BorderRadius.circular(radii.card),
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
              SizedBox(height: spacing.lg),

              // Pickiness
              Text(l10n.pickinessLabel, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
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
                style: typography.labelMedium.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.lg),

              // Allergies
              Text(l10n.allergiesSectionTitle, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
              ChipSelector(
                items: KidFormHelpers.getAllergyChips(l10n),
                selectedIds: _selectedAllergies,
                onChanged: (updated) {
                  setState(() => _selectedAllergies = updated);
                },
              ),
              SizedBox(height: spacing.lg),

              // Dislikes
              Text(l10n.dislikesSectionTitle, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
              ChipSelector(
                items: KidFormHelpers.getDislikeChips(l10n),
                selectedIds: _selectedDislikes,
                onChanged: (updated) {
                  setState(() => _selectedDislikes = updated);
                },
              ),
              SizedBox(height: spacing.lg),

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
              SizedBox(height: spacing.xl),

              // Save button
              AppButton(label: l10n.saveChanges, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddKidBottomSheet extends ConsumerStatefulWidget {
  const _AddKidBottomSheet();

  @override
  ConsumerState<_AddKidBottomSheet> createState() => _AddKidBottomSheetState();
}

class _AddKidBottomSheetState extends ConsumerState<_AddKidBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _avatarId = 'avatar_star';
  int _pickyLevel = 1;
  String _lunchboxType = 'none';
  int _birthYear = DateTime.now().year - 5;
  int _birthMonth = 9;
  Set<String> _selectedAllergies = {};
  Set<String> _selectedDislikes = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final newKid = KidProfile(
      id: 'kid_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      birthDate: DateTime(_birthYear, _birthMonth, 1),
      allergies: _selectedAllergies.toList(),
      dislikes: _selectedDislikes.toList(),
      likes: const [],
      pickyLevel: _pickyLevel,
      lunchboxType: _lunchboxType,
      notes: _avatarId,
    );

    await ref.read(kidsListNotifierProvider.notifier).addKid(newKid);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final currentYear = DateTime.now().year;
    final years = List.generate(14, (i) => currentYear - i);
    final months = List.generate(12, (i) => i + 1);

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radii.cardLg)),
      ),
      padding: EdgeInsetsDirectional.only(
        start: spacing.lg,
        end: spacing.lg,
        top: spacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + spacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.addNewChild, style: typography.titleLarge),
              SizedBox(height: spacing.lg),

              // Avatar
              Text(l10n.avatarSectionTitle, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
              KidAvatarPicker(
                selectedAvatarId: _avatarId,
                onSelected: (id) => setState(() => _avatarId = id),
              ),
              SizedBox(height: spacing.md),

              // Name
              Text(l10n.childNameLabel, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: l10n.childNameHint,
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radii.card),
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
              SizedBox(height: spacing.lg),

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
                          borderRadius: BorderRadius.circular(radii.card),
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
                          borderRadius: BorderRadius.circular(radii.card),
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
              SizedBox(height: spacing.lg),

              // Pickiness
              Text(l10n.pickinessLabel, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
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
                style: typography.labelMedium.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.lg),

              // Allergies
              Text(l10n.allergiesSectionTitle, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
              ChipSelector(
                items: KidFormHelpers.getAllergyChips(l10n),
                selectedIds: _selectedAllergies,
                onChanged: (updated) {
                  setState(() => _selectedAllergies = updated);
                },
              ),
              SizedBox(height: spacing.lg),

              // Dislikes
              Text(l10n.dislikesSectionTitle, style: typography.labelLarge),
              SizedBox(height: spacing.xs),
              ChipSelector(
                items: KidFormHelpers.getDislikeChips(l10n),
                selectedIds: _selectedDislikes,
                onChanged: (updated) {
                  setState(() => _selectedDislikes = updated);
                },
              ),
              SizedBox(height: spacing.lg),

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
              SizedBox(height: spacing.xl),

              AppButton(label: l10n.saveAndContinue, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
