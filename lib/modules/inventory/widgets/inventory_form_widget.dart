import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:d2d_meal_app/core/theme/app_colors.dart';

import '../controller/inventory_controller.dart';
import '../../masters/models/gst_master_model.dart';

class InventoryFormWidget extends StatelessWidget {

  final InventoryController controller;

  final bool isEdit;

  const InventoryFormWidget({
    super.key,
    required this.controller,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // ── ITEM INFO ─────────────────────────────────────
        _SectionHeader(

          icon:
          Icons.inventory_2_outlined,

          label: 'Item Info',
        ),

        const SizedBox(height: 14),

        _DarkTextField(

          controller:
          controller.nameEnController,

          label:
          'Item Name (English)',

          icon:
          Icons.badge_outlined,
        ),

        const SizedBox(height: 14),

        _DarkTextField(

          controller:
          controller.nameTnController,

          label:
          'Item Name (Tamil)',

          icon:
          Icons.translate_rounded,
        ),

        const SizedBox(height: 14),

        _DarkTextField(

          controller:
          controller.codeController,

          label: 'Item Code',

          icon:
          Icons.qr_code_rounded,
        ),

        const SizedBox(height: 14),

        Obx(

              () => _DarkDropdown<String>(

            value:
            controller
                .selectedCategory
                .value,

            label: 'Category',

            icon:
            Icons.category_outlined,

            items:
            controller.categories

                .map(

                  (e) =>
                  DropdownMenuItem(

                    value: e,

                    child: Text(e),
                  ),
            )

                .toList(),

            onChanged: (v) {

              controller
                  .selectedCategory
                  .value = v;
            },
          ),
        ),

        const SizedBox(height: 28),

        // ── STOCK ─────────────────────────────────────────
        _SectionHeader(

          icon:
          Icons.stacked_bar_chart_rounded,

          label: 'Stock Details',
        ),

        const SizedBox(height: 14),

        Row(
          children: [

            Expanded(

              child: _DarkTextField(

                controller:
                controller
                    .stockController,

                label:
                'Current Stock',

                icon:
                Icons.inventory,

                keyboardType:
                TextInputType.number,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(

              child: _DarkTextField(

                controller:
                controller
                    .minStockController,

                label: 'Min Stock',

                icon:
                Icons.warning_amber_rounded,

                keyboardType:
                TextInputType.number,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        _DarkDropdown<String>(

          value:
          controller.selectedUnit.value,

          label: 'Unit',

          icon:
          Icons.scale_outlined,

          items: const [

            DropdownMenuItem(
              value: 'KG',
              child: Text('KG'),
            ),

            DropdownMenuItem(
              value: 'LITRE',
              child: Text('LITRE'),
            ),

            DropdownMenuItem(
              value: 'NOS',
              child: Text('NOS'),
            ),

            DropdownMenuItem(
              value: 'PACKET',
              child: Text('PACKET'),
            ),
          ],

          onChanged: (v) {

            controller
                .selectedUnit.value = v;
          },
        ),

        const SizedBox(height: 28),

        // ── PRICING ───────────────────────────────────────
        _SectionHeader(

          icon:
          Icons.currency_rupee_rounded,

          label: 'Pricing',
        ),

        const SizedBox(height: 14),

        Column(
          children: [

            _DarkTextField(

              controller:
              controller
                  .purchasePriceController,

              label:
              'Purchase Price',

              icon:
              Icons.payments_outlined,

              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 14),

            Obx(

                  () => _DarkDropdown<
                  GstMasterModel>(

                value:
                controller
                    .selectedGst
                    .value,

                label: 'GST Rate',

                icon:
                Icons.percent_rounded,

                items:
                controller.gstRates

                    .map(

                      (e) =>
                      DropdownMenuItem<
                          GstMasterModel>(

                        value: e,

                        child:
                        Text(e.label),
                      ),
                )

                    .toList(),

                onChanged: (v) {

                  controller
                      .selectedGst
                      .value = v;
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ── STATUS ────────────────────────────────────────
        _SectionHeader(

          icon:
          Icons.toggle_on_rounded,

          label: 'Status',
        ),

        const SizedBox(height: 14),

        Obx(

              () => SwitchListTile(

            value:
            controller.active.value,

            onChanged: (v) {

              controller.active.value = v;
            },

            activeColor:
            AppColors.green1,

            tileColor:
            Colors.white.withOpacity(
              0.04,
            ),

            shape:
            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(
                14,
              ),

              side: BorderSide(
                color:
                AppColors.glassBorder,
              ),
            ),

            title: Text(

              controller.active.value
                  ? 'Active'
                  : 'Inactive',

              style: TextStyle(

                color:
                controller.active.value

                    ? AppColors.green1

                    : AppColors
                    .accentRed,

                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {

  final IconData icon;

  final String label;

  const _SectionHeader({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        Icon(

          icon,

          color:
          AppColors.green1,

          size: 16,
        ),

        const SizedBox(width: 8),

        Text(

          label.toUpperCase(),

          style: const TextStyle(

            color:
            AppColors.green1,

            fontSize: 11,

            fontWeight:
            FontWeight.w700,

            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(

          child: Container(

            height: 1,

            color:
            AppColors.glassBorder,
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────

class _DarkTextField extends StatelessWidget {

  final TextEditingController controller;

  final String label;

  final IconData icon;

  final TextInputType? keyboardType;

  const _DarkTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      keyboardType: keyboardType,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration:
      AppColors.darkInput(
        label,
        icon,
      ),
    );
  }
}

// ───────────────────────────────────────────────────────

class _DarkDropdown<T>
    extends StatelessWidget {

  final T? value;

  final String label;

  final IconData icon;

  final List<DropdownMenuItem<T>> items;

  final ValueChanged<T?> onChanged;

  const _DarkDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField<T>(

      value: value,

      isExpanded: true,

      menuMaxHeight: 300,

      borderRadius:
      BorderRadius.circular(16),

      dropdownColor:
      AppColors.bgCard,

      style: const TextStyle(
        color: Colors.white,
      ),

      iconEnabledColor:
      Colors.white70,

      decoration:
      AppColors.darkInput(
        label,
        icon,
      ),

      items: items,

      onChanged: onChanged,
    );
  }
}