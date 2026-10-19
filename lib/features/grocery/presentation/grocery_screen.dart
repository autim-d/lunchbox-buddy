import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunchbox_buddy/core/data/models/grocery_item.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';
import 'package:lunchbox_buddy/core/utils/quantity_formatter.dart';
import 'package:lunchbox_buddy/features/grocery/domain/grocery_merger.dart';
import 'package:lunchbox_buddy/features/grocery/domain/grocery_share_formatter.dart';
import 'package:lunchbox_buddy/features/grocery/presentation/grocery_notifier.dart';
import 'package:lunchbox_buddy/features/grocery/presentation/receipt_paper.dart';
import 'package:share_plus/share_plus.dart';

/// Screen displaying the organized grocery list with:
/// - Receipt printer rollout animation
/// - Aisle-based categorization from canonical ingredients
/// - Tick-off with strikethrough styling
/// - Swipe-to-delete with Undo snackbar
/// - Add manual item dialog
/// - Plain text sharing formatted for WhatsApp
class GroceryListScreen extends ConsumerStatefulWidget {
  const GroceryListScreen({super.key});

  @override
  ConsumerState<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends ConsumerState<GroceryListScreen> {
  final GlobalKey<ReceiptPaperContainerState> _receiptKey =
      GlobalKey<ReceiptPaperContainerState>();
  bool _hasTriggeredInitialPrint = false;

  void _shareViaWhatsApp(List<GroceryItem> items) {
    HapticFeedback.lightImpact();
    final l10n = context.l10n;
    final header = '🛒 ${l10n.groceryTitle} - ${l10n.receiptStoreName}';
    final text = GroceryShareFormatter.formatForWhatsApp(
      items,
      headerTitle: header,
    );
    // ignore: deprecated_member_use
    Share.share(
      text,
      subject: header,
    );
  }

  void _showAddManualItemDialog() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddManualItemBottomSheet(),
    );
  }

  void _confirmClearAll() {
    HapticFeedback.mediumImpact();
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.confirmClearAllTitle),
          content: Text(l10n.confirmClearAllMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ref.read(groceryListNotifierProvider.notifier).clearAll();
              },
              child: Text(
                l10n.clearAllItems,
                style: TextStyle(color: colors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    final groceryAsync = ref.watch(groceryListNotifierProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.groceryTitle,
          style: typography.titleLarge.copyWith(color: colors.textPrimary),
        ),
        actions: [
          // Re-print Receipt Motion CTA
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: l10n.printReceipt,
            onPressed: () {
              HapticFeedback.lightImpact();
              _receiptKey.currentState?.startPrinting();
            },
          ),

          // Share Sheet CTA
          if (groceryAsync.asData?.value.isNotEmpty == true)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: l10n.shareList,
              onPressed: () => _shareViaWhatsApp(groceryAsync.asData!.value),
            ),

          // Menu: Clear Checked / Clear All
          if (groceryAsync.asData?.value.isNotEmpty == true)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'clear_checked') {
                  ref.read(groceryListNotifierProvider.notifier).clearChecked();
                } else if (value == 'clear_all') {
                  _confirmClearAll();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'clear_checked',
                  child: Text(l10n.clearCheckedItems),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Text(
                    l10n.clearAllItems,
                    style: TextStyle(color: colors.error),
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddManualItemDialog,
        backgroundColor: colors.primary,
        foregroundColor: colors.surface,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          l10n.addCustomItem,
          style: typography.labelLarge.copyWith(
            color: colors.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: groceryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            err.toString(),
            style: typography.bodyMedium.copyWith(color: colors.error),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.all(spacing.lg),
                child: _GroceryEmptyState(
                  title: l10n.emptyGroceryTitle,
                  message: l10n.emptyGrocerySubtitle,
                  actionLabel: l10n.addCustomItem,
                  onAction: _showAddManualItemDialog,
                ),
              ),
            );
          }

          // Trigger print animation once when non-empty data is first loaded
          final shouldAnimatePrint = !_hasTriggeredInitialPrint;
          if (!_hasTriggeredInitialPrint) {
            _hasTriggeredInitialPrint = true;
          }

          return SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              start: spacing.md,
              end: spacing.md,
              top: spacing.sm,
              bottom: spacing.xxl * 2,
            ),
            child: ReceiptPaperContainer(
              key: _receiptKey,
              isPrinting: shouldAnimatePrint,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Receipt Top Header
                  _buildReceiptHeader(context, items.length),
                  SizedBox(height: spacing.md),

                  // 2. Aisle Groups
                  ..._buildAisleSections(context, items),

                  SizedBox(height: spacing.lg),

                  // 3. Receipt Action Bar (Share WhatsApp & Quick Add)
                  _buildReceiptFooterActions(context, items),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceiptHeader(BuildContext context, int itemCount) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy/MM/dd - hh:mm a').format(now);

    return Column(
      children: [
        Icon(
          Icons.storefront_rounded,
          size: 28.0,
          color: colors.primary,
        ),
        SizedBox(height: spacing.xs),
        Text(
          l10n.receiptStoreName,
          style: typography.titleLarge.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          l10n.receiptTagline,
          style: typography.bodySmall.copyWith(
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: spacing.xs),
        Text(
          formattedDate,
          style: typography.labelSmall.copyWith(
            color: colors.textSecondary.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: spacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.ingredientsCountLabel(itemCount),
              style: typography.labelSmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '#LB-${itemCount.toString().padLeft(3, '0')}',
              style: typography.labelSmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        // Dotted perforation visual divider
        Text(
          '• • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •',
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: typography.bodySmall.copyWith(
            color: colors.border,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAisleSections(BuildContext context, List<GroceryItem> items) {
    const spacing = AppTokens.spacing;

    // Group items by aisle key
    final Map<String, List<GroceryItem>> grouped = {};
    for (final item in items) {
      final aisleKey = item.aisle.trim().toLowerCase();
      final normalizedKey = aisleKey == 'meat' ? 'protein' : aisleKey;
      grouped.putIfAbsent(normalizedKey, () => []).add(item);
    }

    // Sort aisles using AisleMetadata sortOrder
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final orderA = GroceryShareFormatter.getAisleMetadata(a).sortOrder;
        final orderB = GroceryShareFormatter.getAisleMetadata(b).sortOrder;
        return orderA.compareTo(orderB);
      });

    final widgets = <Widget>[];

    for (final aisleKey in sortedKeys) {
      final aisleItems = grouped[aisleKey]!;
      final metadata = GroceryShareFormatter.getAisleMetadata(aisleKey);

      widgets.add(
        _AisleGroupSection(
          metadata: metadata,
          items: aisleItems,
          onToggleItem: (id) =>
              ref.read(groceryListNotifierProvider.notifier).toggleItem(id),
          onDeleteItem: (item) => _deleteItemWithUndo(context, item),
        ),
      );
      widgets.add(SizedBox(height: spacing.md));
    }

    return widgets;
  }

  void _deleteItemWithUndo(BuildContext context, GroceryItem item) {
    final l10n = context.l10n;
    ref.read(groceryListNotifierProvider.notifier).deleteItem(item.id);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.itemDeleted}: ${item.nameAr}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () {
            ref.read(groceryListNotifierProvider.notifier).restoreItem(item);
          },
        ),
      ),
    );
  }

  Widget _buildReceiptFooterActions(BuildContext context, List<GroceryItem> items) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;

    return Column(
      children: [
        // Dotted divider
        Text(
          '• • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •',
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: AppTokens.typography.bodySmall.copyWith(
            color: colors.border,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: spacing.md),

        // WhatsApp Share Button
        AppButton(
          label: l10n.shareListWhatsApp,
          icon: Icons.send_rounded,
          onPressed: () => _shareViaWhatsApp(items),
        ),
      ],
    );
  }
}

/// Aisle category section containing grocery list tile items
class _AisleGroupSection extends StatelessWidget {
  const _AisleGroupSection({
    required this.metadata,
    required this.items,
    required this.onToggleItem,
    required this.onDeleteItem,
  });

  final AisleMetadata metadata;
  final List<GroceryItem> items;
  final ValueChanged<String> onToggleItem;
  final ValueChanged<GroceryItem> onDeleteItem;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final checkedCount = items.where((it) => it.isChecked).length;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceSubtle.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(radii.md),
        border: Border.all(color: colors.borderSubtle),
      ),
      padding: EdgeInsetsDirectional.all(spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Aisle Header
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: spacing.xs,
              end: spacing.xs,
              top: spacing.xs,
              bottom: spacing.xs,
            ),
            child: Row(
              children: [
                Text(
                  metadata.iconEmoji,
                  style: const TextStyle(fontSize: 18.0),
                ),
                SizedBox(width: spacing.xs),
                Expanded(
                  child: Text(
                    metadata.nameAr,
                    style: typography.titleSmall.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: spacing.xs,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(radii.full),
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    '$checkedCount/${items.length}',
                    style: typography.labelSmall.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 8.0, thickness: 0.5),

          // Items List with Dismissible
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1.0, thickness: 0.5),
            itemBuilder: (context, index) {
              final item = items[index];
              return _GroceryItemTile(
                item: item,
                onToggle: () => onToggleItem(item.id),
                onDismissed: () => onDeleteItem(item),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Individual item tile with strikethrough styling and swipe-to-delete
class _GroceryItemTile extends StatelessWidget {
  const _GroceryItemTile({
    required this.item,
    required this.onToggle,
    required this.onDismissed,
  });

  final GroceryItem item;
  final VoidCallback onToggle;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final isChecked = item.isChecked;

    // Quantity & Unit string
    String? quantityString;
    if (item.quantity != null && item.quantity! > 0) {
      final formattedQty = QuantityFormatter.format(item.quantity);
      final formattedUnit = UnitConverter.formatUnitAr(item.unit);
      quantityString = formattedUnit.isNotEmpty
          ? '$formattedQty $formattedUnit'
          : formattedQty;
    }

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsetsDirectional.only(end: spacing.md),
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(radii.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: colors.error, size: 20.0),
            SizedBox(width: spacing.xs),
            Text(
              context.l10n.remove,
              style: typography.labelSmall.copyWith(
                color: colors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDismissed();
      },
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onToggle();
        },
        borderRadius: BorderRadius.circular(radii.sm),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: spacing.xs,
            vertical: spacing.sm,
          ),
          child: Row(
            children: [
              // Checkbox button
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: isChecked ? colors.secondary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isChecked ? colors.secondary : colors.border,
                    width: 1.5,
                  ),
                ),
                child: isChecked
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14.0,
                        color: Colors.white,
                      )
                    : null,
              ),
              SizedBox(width: spacing.sm),

              // Item Name with Strikethrough
              Expanded(
                child: Text(
                  item.nameAr,
                  style: typography.bodyMedium.copyWith(
                    color: isChecked
                        ? colors.textSecondary.withValues(alpha: 0.6)
                        : colors.textPrimary,
                    decoration: isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontWeight: isChecked ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
              ),

              // Quantity & Unit badge
              if (quantityString != null)
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: spacing.xs,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: isChecked
                        ? colors.surfaceSubtle
                        : colors.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(radii.sm),
                    border: Border.all(
                      color: isChecked
                          ? colors.border
                          : colors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    quantityString,
                    style: typography.labelSmall.copyWith(
                      color: isChecked
                          ? colors.textSecondary.withValues(alpha: 0.6)
                          : colors.primary,
                      fontWeight: FontWeight.bold,
                      decoration: isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
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

/// Bottom sheet dialog to manually add custom grocery items
class _AddManualItemBottomSheet extends ConsumerStatefulWidget {
  const _AddManualItemBottomSheet();

  @override
  ConsumerState<_AddManualItemBottomSheet> createState() =>
      _AddManualItemBottomSheetState();
}

class _AddManualItemBottomSheetState
    extends ConsumerState<_AddManualItemBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  String _selectedAisle = 'produce';
  String? _selectedUnit = 'piece';

  static const List<({String label, String value})> _units = [
    (label: 'حبة', value: 'piece'),
    (label: 'جرام', value: 'g'),
    (label: 'كجم', value: 'kg'),
    (label: 'مل', value: 'ml'),
    (label: 'لتر', value: 'l'),
    (label: 'كوب', value: 'cup'),
    (label: 'ملعقة كبيرة', value: 'tbsp'),
    (label: 'ملعقة صغيرة', value: 'tsp'),
    (label: 'شريحة', value: 'slices'),
    (label: 'علبة', value: 'can'),
    (label: 'رشة', value: 'pinch'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final quantityText = _quantityController.text.trim();
    final quantity = double.tryParse(quantityText);

    HapticFeedback.lightImpact();
    ref.read(groceryListNotifierProvider.notifier).addManualItem(
          nameAr: name,
          quantity: quantity,
          unit: _selectedUnit,
          aisle: _selectedAisle,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsetsDirectional.only(
        start: spacing.lg,
        end: spacing.lg,
        top: spacing.lg,
        bottom: spacing.lg + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radii.card),
          topRight: Radius.circular(radii.card),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.addItemTitle,
                  style: typography.titleMedium.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: spacing.md),

            // Item Name TextField
            TextField(
              controller: _nameController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.itemNameLabel,
                hintText: 'مثال: حليب، خيار، طحينة...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radii.md),
                ),
              ),
            ),
            SizedBox(height: spacing.md),

            // Quantity & Unit Row
            Row(
              children: [
                // Quantity
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: l10n.itemQuantityLabel,
                      hintText: '1.5',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radii.md),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing.sm),

                // Unit Dropdown
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedUnit,
                    decoration: InputDecoration(
                      labelText: l10n.itemUnitLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radii.md),
                      ),
                    ),
                    items: _units.map((unit) {
                      return DropdownMenuItem(
                        value: unit.value,
                        child: Text(unit.label),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedUnit = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.md),

            // Aisle Selector
            DropdownButtonFormField<String>(
              initialValue: _selectedAisle,
              decoration: InputDecoration(
                labelText: l10n.itemAisleLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radii.md),
                ),
              ),
              items: GroceryShareFormatter.aisles.map((aisle) {
                return DropdownMenuItem(
                  value: aisle.key,
                  child: Row(
                    children: [
                      Text(aisle.iconEmoji),
                      SizedBox(width: spacing.xs),
                      Text(aisle.nameAr),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedAisle = val;
                  });
                }
              },
            ),
            SizedBox(height: spacing.lg),

            // Submit Button
            AppButton(
              label: l10n.addCustomItem,
              icon: Icons.check_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state widget shown when the grocery list is empty
class _GroceryEmptyState extends StatelessWidget {
  const _GroceryEmptyState({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const typography = AppTokens.typography;

    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                size: 40.0,
                color: colors.primary,
              ),
            ),
            SizedBox(height: spacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: typography.titleLarge.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: typography.bodyMedium.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: spacing.lg),
            AppButton(
              label: actionLabel,
              icon: Icons.add_rounded,
              onPressed: onAction,
            ),
          ],
        ),
      ),
    );
  }
}
