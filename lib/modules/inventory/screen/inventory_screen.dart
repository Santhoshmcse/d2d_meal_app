import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:d2d_meal_app/core/theme/app_colors.dart';
import 'package:d2d_meal_app/core/widgets/api_state_widget.dart';
import 'package:d2d_meal_app/core/widgets/confirmation_dialog.dart';

import '../controller/inventory_controller.dart';
import '../model/inventory_item_model.dart';
import '../screen/add_inventory_item_screen.dart';
import '../screen/edit_inventory_item_screen.dart';

class InventoryScreen extends StatelessWidget {
  InventoryScreen({super.key});

  final InventoryController controller = Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.bgCard,
        elevation: 0,
        title: const Text(
          'Inventory',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          Obx(
                () => controller.isLoading.value
                ? const SizedBox(
              width: 48,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.green1,
                  ),
                ),
              ),
            )
                : IconButton(
              icon: const Icon(Icons.refresh_rounded,
                  color: Colors.white70),
              tooltip: 'Refresh',
              onPressed: controller.refreshItems,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.glassBorder),
        ),
      ),

      // ── FAB ────────────────────────────────────────────────────────────────
      floatingActionButton: _GreenFab(
        onPressed: () async {
          final result = await Get.to(() => AddInventoryItemScreen());
          if (result == true) controller.refreshItems();
        },
      ),

      body: Column(
        children: [
          // ── Search ──────────────────────────────────────────────────────────
          _SearchBar(controller: controller),

          // ── Stats + Filter strip ────────────────────────────────────────────
          Obx(() {
            return _FilterStatsBar(
              total: controller.totalCount,
              inStock: controller.inStockCount,
              lowStock: controller.lowStockCount,
              outOfStock: controller.outOfStockCount,
              selectedFilter: controller.stockFilter.value,
              onFilterChanged: controller.setStockFilter,
            );
          }),

          // ── Category chip row ───────────────────────────────────────────────
          Obx(() {
            final cats = controller.categories;
            if (cats.isEmpty) return const SizedBox.shrink();
            return _CategoryChipRow(
              categories: cats,
              selected: controller.categoryFilter.value,
              onSelected: controller.setCategoryFilter,
            );
          }),

          // ── List ────────────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              return ApiStateWidget(
                isLoading: controller.isLoading.value,
                errorMessage: controller.errorMessage.value,
                isEmpty: !controller.isLoading.value &&
                    controller.filteredItems.isEmpty,
                onRetry: controller.loadItems,
                emptyTitle: 'No Items Found',
                emptySubtitle: controller.searchController.text.isNotEmpty
                    ? 'Try a different keyword or filter.'
                    : 'Tap "Add Item" to get started.',
                emptyIcon: Icons.inventory_2_outlined,
                child: RefreshIndicator(
                  color: AppColors.green1,
                  backgroundColor: AppColors.bgCard,
                  onRefresh: controller.refreshItems,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 110),
                    itemCount: controller.filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = controller.filteredItems[index];
                      return _InventoryCard(
                        item: item,
                        controller: controller,
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Green FAB ────────────────────────────────────────────────────────────────

class _GreenFab extends StatelessWidget {
  const _GreenFab({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradientH,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.greenGlow(),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 20),
            SizedBox(width: 6),
            Text(
              'Add Item',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final InventoryController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgCard,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearch,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by name, code, category…',
          hintStyle:
          TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded,
              color: Colors.white.withOpacity(0.40), size: 20),
          suffixIcon: Obx(
                () => controller.hasSearchText.value
                ? IconButton(
              icon: Icon(Icons.clear_rounded,
                  color: Colors.white.withOpacity(0.50), size: 18),
              onPressed: () {
                controller.searchController.clear();
                controller.onSearch('');
              },
            )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.glassBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.green1, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

// ─── Filter + Stats Bar ───────────────────────────────────────────────────────

class _FilterStatsBar extends StatelessWidget {
  const _FilterStatsBar({
    required this.total,
    required this.inStock,
    required this.lowStock,
    required this.outOfStock,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final int total;
  final int inStock;
  final int lowStock;
  final int outOfStock;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgCard,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Row(
        children: [
          _FilterPill(
            label: 'All',
            count: total,
            color: AppColors.green1,
            selected: selectedFilter == 'all',
            onTap: () => onFilterChanged('all'),
          ),
          const SizedBox(width: 8),
          _FilterPill(
            label: 'Low',
            count: lowStock,
            color: AppColors.accentAmber,
            selected: selectedFilter == 'low',
            onTap: () => onFilterChanged('low'),
          ),
          const SizedBox(width: 8),
          _FilterPill(
            label: 'Out',
            count: outOfStock,
            color: AppColors.accentRed,
            selected: selectedFilter == 'out',
            onTap: () => onFilterChanged('out'),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.count,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.20) : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : color.withOpacity(0.25),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              '$label  $count',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category Chip Row ────────────────────────────────────────────────────────

class _CategoryChipRow extends StatelessWidget {
  const _CategoryChipRow({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgCard,
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All categories" chip
            final isSelected = selected == null;
            return _CategoryChip(
              label: 'All',
              selected: isSelected,
              onTap: () => onSelected(null),
            );
          }
          final cat = categories[index - 1];
          return _CategoryChip(
            label: cat,
            selected: selected == cat,
            onTap: () => onSelected(selected == cat ? null : cat),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.green1.withOpacity(0.20)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.green1
                : AppColors.glassBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.green1 : Colors.white54,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─── Inventory Card ───────────────────────────────────────────────────────────

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({
    required this.item,
    required this.controller,
  });

  final InventoryItemModel item;
  final InventoryController controller;

  Color get _statusColor {
    return switch (item.stockStatus) {
      StockStatus.outOfStock => AppColors.accentRed,
      StockStatus.lowStock => AppColors.accentAmber,
      StockStatus.inStock => AppColors.accentTeal,
    };
  }

  String get _statusLabel {
    return switch (item.stockStatus) {
      StockStatus.outOfStock => 'Out of Stock',
      StockStatus.lowStock => 'Low Stock',
      StockStatus.inStock => 'In Stock',
    };
  }

  IconData get _statusIcon {
    return switch (item.stockStatus) {
      StockStatus.outOfStock => Icons.remove_shopping_cart_outlined,
      StockStatus.lowStock => Icons.warning_amber_rounded,
      StockStatus.inStock => Icons.check_circle_outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.green1.withOpacity(0.07),
          onTap: () async {
            await Get.to(() => EditInventoryItemScreen(item: item));
            controller.refreshItems();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: Icon + Name + Status chip ──────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category icon container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.25)),
                      ),
                      child: Icon(_statusIcon, color: color, size: 22),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nameEn,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.nameTn,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Status chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.30)),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Row 2: Code · Category ─────────────────────────────────
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.qr_code_rounded,
                      text: item.code,
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.category_outlined,
                      text: item.categoryName,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Divider ────────────────────────────────────────────────
                Container(height: 1, color: AppColors.glassBorder),

                const SizedBox(height: 10),

                // ── Row 3: Stock info + Actions ────────────────────────────
                Row(
                  children: [
                    // Current stock
                    Expanded(
                      child: _StockMetric(
                        label: 'Current',
                        value: item.stockDisplay,
                        color: color,
                      ),
                    ),
                    // Min stock
                    Expanded(
                      child: _StockMetric(
                        label: 'Min Level',
                        value: item.minStockDisplay,
                        color: Colors.white38,
                      ),
                    ),
                    // Unit
                    Expanded(
                      child: _StockMetric(
                        label: 'Unit',
                        value: item.unit,
                        color: Colors.white38,
                      ),
                    ),

                    // Action buttons
                    _ActionButton(
                      icon: item.active
                          ? Icons.toggle_on_rounded
                          : Icons.toggle_off_rounded,
                      label: item.active ? 'Deactivate' : 'Activate',
                      color: item.active
                          ? AppColors.accentAmber
                          : AppColors.accentTeal,
                      onTap: () => _onToggleTap(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onToggleTap(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      title: item.active ? 'Deactivate Item' : 'Activate Item',
      message: item.active
          ? '${item.nameEn} will be marked inactive.'
          : '${item.nameEn} will be marked active.',
      confirmLabel: item.active ? 'Deactivate' : 'Activate',
      isDestructive: item.active,
      icon: item.active
          ? Icons.toggle_off_rounded
          : Icons.toggle_on_rounded,
      iconColor:
      item.active ? AppColors.accentAmber : AppColors.accentTeal,
    );
    if (confirmed == true) {
      controller.toggleItemStatus(item);
    }
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white38),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StockMetric extends StatelessWidget {
  const _StockMetric({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}