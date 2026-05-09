import 'package:d2d_meal_app/core/network/api_service.dart';
import '../model/inventory_item_model.dart';

class InventoryService {
  static const String _base = '/api/admin/inventory/items';

  // ── GET all items ──────────────────────────────────────────────────────────
  static Future<List<InventoryItemModel>> getItems() async {
    final res = await ApiService.dio.get(_base);
    final list = res.data as List<dynamic>;
    return list
        .map((e) => InventoryItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── GET single item ────────────────────────────────────────────────────────
  static Future<InventoryItemModel> getItemById(int id) async {
    final res = await ApiService.dio.get('$_base/$id');
    return InventoryItemModel.fromJson(res.data as Map<String, dynamic>);
  }

  // ── GET active items only ──────────────────────────────────────────────────
  static Future<List<InventoryItemModel>> getActiveItems() async {
    final res = await ApiService.dio.get('$_base/active');
    final list = res.data as List<dynamic>;
    return list
        .map((e) => InventoryItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── POST create item ───────────────────────────────────────────────────────
  static Future<void> createItem(Map<String, dynamic> data) async {
    await ApiService.dio.post(_base, data: data);
  }

  // ── PUT full update ────────────────────────────────────────────────────────
  static Future<void> updateItem(int id, Map<String, dynamic> data) async {
    await ApiService.dio.put('$_base/$id', data: data);
  }

  // ── PATCH partial update ───────────────────────────────────────────────────
  static Future<void> patchItem(int id, Map<String, dynamic> data) async {
    await ApiService.dio.patch('$_base/$id', data: data);
  }

  // ── PATCH activate / deactivate ───────────────────────────────────────────
  static Future<void> activateItem(int id) async {
    await ApiService.dio.patch('$_base/$id/activate');
  }

  static Future<void> deactivateItem(int id) async {
    await ApiService.dio.patch('$_base/$id/deactivate');
  }
}