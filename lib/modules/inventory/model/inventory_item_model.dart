class InventoryItemModel {
  final int id;
  final String nameEn;
  final String nameTn;
  final String code;
  final int categoryId;
  final String categoryName;
  final int unitId;
  final String unit;
  final bool active;
  final String? nextExpiryDate;
  final double averageCost;
  final double gstRate;
  final double currentStock;
  final double stockValue;
  final double minStockLevel;
  final bool lowStock;
  final bool outOfStock;

  const InventoryItemModel({
    required this.id,
    required this.nameEn,
    required this.nameTn,
    required this.code,
    required this.categoryId,
    required this.categoryName,
    required this.unitId,
    required this.unit,
    required this.active,
    this.nextExpiryDate,
    required this.averageCost,
    required this.gstRate,
    required this.currentStock,
    required this.stockValue,
    required this.minStockLevel,
    required this.lowStock,
    required this.outOfStock,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'] as int,
      nameEn: json['nameEn'] as String,
      nameTn: json['nameTn'] as String,
      code: json['code'] as String,
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      unitId: json['unitId'] as int,
      unit: json['unit'] as String,
      active: json['active'] as bool,
      nextExpiryDate: json['nextExpiryDate'] as String?,
      averageCost: (json['averageCost'] as num).toDouble(),
      gstRate: (json['gstRate'] as num).toDouble(),
      currentStock: (json['currentStock'] as num).toDouble(),
      stockValue: (json['stockValue'] as num).toDouble(),
      minStockLevel: (json['minStockLevel'] as num).toDouble(),
      lowStock: json['lowStock'] as bool,
      outOfStock: json['outOfStock'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'nameEn': nameEn,
    'nameTn': nameTn,
    'code': code,
    'categoryId': categoryId,
    'unitId': unitId,
    'active': active,
    'gstRate': gstRate,
    'minStockLevel': minStockLevel,
  };

  // Stock status helper
  StockStatus get stockStatus {
    if (outOfStock || currentStock == 0) return StockStatus.outOfStock;
    if (lowStock) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  String get stockDisplay {
    if (currentStock == currentStock.roundToDouble()) {
      return '${currentStock.toInt()} $unit';
    }
    return '${currentStock.toStringAsFixed(2)} $unit';
  }

  String get minStockDisplay {
    if (minStockLevel == minStockLevel.roundToDouble()) {
      return '${minStockLevel.toInt()} $unit';
    }
    return '${minStockLevel.toStringAsFixed(2)} $unit';
  }
}

enum StockStatus { inStock, lowStock, outOfStock }