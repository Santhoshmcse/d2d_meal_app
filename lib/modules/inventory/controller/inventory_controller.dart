import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/inventory_item_model.dart';
import '../service/inventory_service.dart';
import '../../masters/models/gst_master_model.dart';
import '../../masters/services/master_service.dart';

class InventoryController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  final RxList<InventoryItemModel> allItems = <InventoryItemModel>[].obs;
  final RxList<InventoryItemModel> filteredItems = <InventoryItemModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Search & filter ────────────────────────────────────────────────────────
  final searchController = TextEditingController();
  final RxBool hasSearchText = false.obs;

  // Filter: 'all' | 'low' | 'out'
  final RxString stockFilter = 'all'.obs;

  // Filter: null = all categories
  final RxnString categoryFilter = RxnString(null);

  final nameEnController = TextEditingController();
  final nameTnController = TextEditingController();
  final codeController = TextEditingController();

  final stockController = TextEditingController();
  final minStockController = TextEditingController();

  final purchasePriceController = TextEditingController();


  final selectedCategory = RxnString();
  final selectedUnit = RxnString();
  final gstRates =
      <GstMasterModel>[].obs;

  final selectedGst =
  Rxn<GstMasterModel>();
  final active = true.obs;

  final isSaving = false.obs;

  // ── Category list (derived) ────────────────────────────────────────────────
  List<String> get categories {
    final cats = allItems.map((e) => e.categoryName).toSet().toList();
    cats.sort();
    return cats;
  }

  @override
  void onInit() {
    super.onInit();
    loadItems();
    loadGstRates();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ── Load ───────────────────────────────────────────────────────────────────
  Future<void> loadItems() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await InventoryService.getItems();
      allItems.assignAll(data);
      _applyFilters();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshItems() async => loadItems();

  Future<void> loadGstRates() async {

    try {

      final data =
      await MasterService
          .getGstRates();

      gstRates.assignAll(data);

    } catch (e) {

      debugPrint(
        'GST Load Failed: $e',
      );
    }
  }
  // ── Search ─────────────────────────────────────────────────────────────────
  void onSearch(String query) {

    hasSearchText.value =
        query.trim().isNotEmpty;

    final q =
    query.trim().toLowerCase();

    final result = allItems.where((item) {

      final matchesSearch =
          q.isEmpty ||

              item.nameEn
                  .toLowerCase()
                  .contains(q) ||

              item.nameTn
                  .toLowerCase()
                  .contains(q) ||

              item.code
                  .toLowerCase()
                  .contains(q) ||

              item.categoryName
                  .toLowerCase()
                  .contains(q);

      final matchesStock =
      switch (stockFilter.value) {

        'low' =>
        item.lowStock,

        'out' =>
        item.outOfStock ||
            item.currentStock == 0,

        _ =>
        true,
      };

      final matchesCategory =
          categoryFilter.value == null ||

              item.categoryName ==
                  categoryFilter.value;

      return matchesSearch &&
          matchesStock &&
          matchesCategory;

    }).toList();

    filteredItems.assignAll(result);
  }

  // ── Stock filter ───────────────────────────────────────────────────────────
  void setStockFilter(String filter) {
    stockFilter.value = filter;
    _applyFilters();
  }

  // ── Category filter ────────────────────────────────────────────────────────
  void setCategoryFilter(String? cat) {
    categoryFilter.value = cat;
    _applyFilters();
  }

  // ── Combined filter logic ──────────────────────────────────────────────────
  void _applyFilters() {
    final q = searchController.text.toLowerCase();

    var result = allItems.where((item) {
      // Search
      final matchesSearch = q.isEmpty ||
          item.nameEn.toLowerCase().contains(q) ||
          item.nameTn.toLowerCase().contains(q) ||
          item.code.toLowerCase().contains(q) ||
          item.categoryName.toLowerCase().contains(q);

      // Stock filter
      final matchesStock = switch (stockFilter.value) {
        'low' => item.lowStock,
        'out' => item.outOfStock || item.currentStock == 0,
        _ => true,
      };

      // Category filter
      final matchesCategory = categoryFilter.value == null ||
          item.categoryName == categoryFilter.value;

      return matchesSearch && matchesStock && matchesCategory;
    }).toList();

    filteredItems.assignAll(result);
  }

  // ── Toggle active/inactive ─────────────────────────────────────────────────
  Future<void> toggleItemStatus(InventoryItemModel item) async {
    try {
      if (item.active) {
        await InventoryService.deactivateItem(item.id);
      } else {
        await InventoryService.activateItem(item.id);
      }
      await loadItems();
      Get.snackbar(
        item.active ? 'Deactivated' : 'Activated',
        '${item.nameEn} has been ${item.active ? 'deactivated' : 'activated'}.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: item.active
            ? const Color(0xFFFF6B6B).withOpacity(0.9)
            : const Color(0xFF2EBD52),
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      _showError('Failed to update status: $e');
    }
  }

  // ── Create ─────────────────────────────────────────────────────────────────
  Future<bool> createItem(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    try {
      await InventoryService.createItem(data);
      await loadItems();
      return true;
    } catch (e) {
      _showError('Create failed: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Update ─────────────────────────────────────────────────────────────────
  Future<bool> updateItem(int id, Map<String, dynamic> data) async {
    isSubmitting.value = true;
    try {
      await InventoryService.updateItem(id, data);
      await loadItems();
      return true;
    } catch (e) {
      _showError('Update failed: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  void loadItemForEdit(
      InventoryItemModel item) {

    nameEnController.text =
        item.nameEn;

    nameTnController.text =
        item.nameTn;

    codeController.text =
        item.code;

    stockController.text =
        item.currentStock.toString();

    minStockController.text =
        item.minStockLevel.toString();

    purchasePriceController.text =
        item.averageCost.toString();

    selectedGst.value =
        gstRates.firstWhereOrNull(

              (e) {

            final rate =
                double.tryParse(
                  e.label.replaceAll(
                    '%',
                    '',
                  ),
                ) ?? 0;

            return rate ==
                item.gstRate;
          },
        );

    selectedCategory.value =
        item.categoryName;

    selectedUnit.value =
        item.unit;

    active.value =
        item.active;
  }

  void _showError(String msg) {
    Get.snackbar(
      'Error',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // ── Stats (used in screen) ─────────────────────────────────────────────────
  int get totalCount => allItems.length;
  int get lowStockCount => allItems.where((e) => e.lowStock).length;
  int get outOfStockCount =>
      allItems.where((e) => e.outOfStock || e.currentStock == 0).length;
  int get inStockCount =>
      allItems.where((e) => !e.lowStock && e.currentStock > 0).length;
}