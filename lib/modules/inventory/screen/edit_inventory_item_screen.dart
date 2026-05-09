import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:d2d_meal_app/core/theme/app_colors.dart';

import '../controller/inventory_controller.dart';
import '../model/inventory_item_model.dart';
import '../widgets/inventory_form_widget.dart';

class EditInventoryItemScreen extends StatefulWidget {
  final InventoryItemModel item;

  const EditInventoryItemScreen({super.key, required this.item});

  @override
  State<EditInventoryItemScreen> createState() =>
      _EditInventoryItemScreenState();
}

class _EditInventoryItemScreenState extends State<EditInventoryItemScreen> {
  final InventoryController controller = Get.find<InventoryController>();

  @override
  void initState() {
    super.initState();

    controller.loadItemForEdit(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: AppColors.bgCard,

        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Edit Inventory',

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),

            Text(
              widget.item.code,

              style: TextStyle(
                color: Colors.white.withOpacity(0.45),

                fontSize: 11,
              ),
            ),
          ],
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),

          child: Container(height: 1, color: AppColors.glassBorder),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: InventoryFormWidget(controller: controller, isEdit: true),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),

            decoration: BoxDecoration(
              color: AppColors.bgCard,

              border: Border(top: BorderSide(color: AppColors.glassBorder)),
            ),

            child: Obx(
              () => GestureDetector(
                onTap: controller.isSubmitting.value
                    ? null
                    : () async {
                        await controller.updateItem(widget.item.id, {
                          "nameEn": controller.nameEnController.text,

                          "nameTn": controller.nameTnController.text,

                          "code": controller.codeController.text,

                          // TEMP STATIC IDS
                          "categoryId": 1,

                          "unitId": 1,

                          "active": controller.active.value,

                          "gstRate":
                              double.tryParse(
                                controller.selectedGst.value?.label.replaceAll(
                                      '%',
                                      '',
                                    ) ??
                                    '0',
                              ) ??
                              0,

                          "currentStock":
                              double.tryParse(
                                controller.stockController.text,
                              ) ??
                              0,

                          "averageCost":
                              double.tryParse(
                                controller.purchasePriceController.text,
                              ) ??
                              0,

                          "minStockLevel":
                              double.tryParse(
                                controller.minStockController.text,
                              ) ??
                              0,
                        });
                      },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),

                  width: double.infinity,

                  height: 54,

                  decoration: BoxDecoration(
                    gradient: controller.isSubmitting.value
                        ? AppColors.disabledGradient
                        : AppColors.primaryGradientH,

                    borderRadius: BorderRadius.circular(16),

                    boxShadow: controller.isSubmitting.value
                        ? []
                        : AppColors.greenGlow(),
                  ),

                  child: Center(
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,

                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'UPDATE ITEM',

                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
