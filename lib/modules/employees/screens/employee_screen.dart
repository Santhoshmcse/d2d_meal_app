import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:d2d_meal_app/core/theme/app_colors.dart';
import '../../../../core/widgets/api_state_widget.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../controllers/employee_controller.dart';
import '../models/employee_model.dart';
import 'add_employee_screen.dart';
import 'edit_employee_screen.dart';

class EmployeeScreen extends StatelessWidget {
  EmployeeScreen({super.key});

  final EmployeeController controller = Get.put(EmployeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      // ── AppBar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.bgCard,
        elevation: 0,
        title: const Text(
          'Employees',
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
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white70,
              ),
              tooltip: 'Refresh',
              onPressed: controller.refreshEmployees,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.glassBorder),
        ),
      ),

      // ── FAB ─────────────────────────────────────────────────────────────
      floatingActionButton: _GreenFab(
        onPressed: () async {
          final result = await Get.to(() => AddEmployeeScreen());
          if (result == true) controller.refreshEmployees();
        },
      ),

      body: Column(
        children: [
          // ── Search Bar ─────────────────────────────────────────────────
          _SearchBar(controller: controller),

          // ── Stats Strip ────────────────────────────────────────────────
          Obx(() {
            final all = controller.filteredEmployees;
            final activeCount = all.where((e) => e.active).length;
            final inactiveCount = all.length - activeCount;
            return _StatsStrip(
              total: all.length,
              activeCount: activeCount,
              inactiveCount: inactiveCount,
            );
          }),

          // ── List ───────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              return ApiStateWidget(
                isLoading: controller.isLoading.value,
                errorMessage: controller.errorMessage.value,
                isEmpty: !controller.isLoading.value &&
                    controller.filteredEmployees.isEmpty,
                onRetry: controller.loadEmployees,
                emptyTitle: 'No Employees Found',
                emptySubtitle: controller.searchController.text.isNotEmpty
                    ? 'Try a different search keyword.'
                    : 'Tap "Add Employee" to get started.',
                emptyIcon: Icons.people_outline_rounded,
                child: RefreshIndicator(
                  color: AppColors.green1,
                  backgroundColor: AppColors.bgCard,
                  onRefresh: controller.refreshEmployees,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 110),
                    itemCount: controller.filteredEmployees.length +
                        (controller.isLoadMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.filteredEmployees.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.green1,
                            ),
                          ),
                        );
                      }
                      final employee = controller.filteredEmployees[index];
                      return _EmployeeCard(
                        employee: employee,
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
            Icon(Icons.person_add_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Add Employee',
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
  final EmployeeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgCard,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.searchEmployee,
        textInputAction: TextInputAction.search,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by name, code, department…',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.40),
            size: 20,
          ),
          suffixIcon: Obx(
                () => controller.hasSearchText.value
                ? IconButton(
              icon: Icon(
                Icons.clear_rounded,
                color: Colors.white.withOpacity(0.50),
                size: 18,
              ),
              onPressed: () {
                controller.searchController.clear();
                controller.searchEmployee('');
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

// ─── Stats Strip ──────────────────────────────────────────────────────────────

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({
    required this.total,
    required this.activeCount,
    required this.inactiveCount,
  });

  final int total;
  final int activeCount;
  final int inactiveCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgCard,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Row(
        children: [
          _StatPill(label: 'Total', count: total, color: AppColors.green1),
          const SizedBox(width: 8),
          _StatPill(label: 'Active', count: activeCount, color: AppColors.accentTeal),
          const SizedBox(width: 8),
          _StatPill(label: 'Inactive', count: inactiveCount, color: AppColors.accentRed),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.count,
    required this.color,
  });
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label  $count',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Employee Card ────────────────────────────────────────────────────────────

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({
    required this.employee,
    required this.controller,
  });

  final EmployeeModel employee;
  final EmployeeController controller;

  @override
  Widget build(BuildContext context) {
    final isActive = employee.active;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppColors.green1.withOpacity(0.20)
              : AppColors.accentRed.withOpacity(0.20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.green1.withOpacity(0.08),
          highlightColor: AppColors.green1.withOpacity(0.04),
          onTap: () async {
            await Get.to(() => EditEmployeeScreen(employee: employee));
            controller.refreshEmployees();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar ──────────────────────────────────────────────
                _Avatar(employee: employee),

                const SizedBox(width: 12),

                // ── Details ─────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + badge row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              employee.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusChip(isActive: isActive),
                        ],
                      ),

                      const SizedBox(height: 6),

                      _InfoRow(
                        icon: Icons.badge_outlined,
                        text: employee.employeeCode,
                      ),
                      _InfoRow(
                        icon: Icons.work_outline_rounded,
                        text:
                        '${employee.deptName ?? '—'} · ${employee.desigName ?? '—'}',
                      ),
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        text: employee.locationName ?? '—',
                      ),
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        text: 'DOJ: ${employee.doj}',
                      ),
                      if (employee.biometricId != null &&
                          employee.biometricId!.isNotEmpty)
                        _InfoRow(
                          icon: Icons.fingerprint_rounded,
                          text: 'Biometric: ${employee.biometricId}',
                        ),

                      const SizedBox(height: 10),

                      // ── Divider ────────────────────────────────────────
                      Container(
                        height: 1,
                        color: AppColors.glassBorder,
                        margin: const EdgeInsets.only(bottom: 10),
                      ),

                      // ── Action Buttons ─────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _ActionButton(
                            icon: isActive
                                ? Icons.toggle_on_rounded
                                : Icons.toggle_off_rounded,
                            label: isActive ? 'Deactivate' : 'Activate',
                            color: isActive
                                ? AppColors.accentAmber
                                : AppColors.accentTeal,
                            onTap: () => _onToggleTap(context),
                          ),
                          const SizedBox(width: 8),
                          _ActionButton(
                            icon: Icons.delete_outline_rounded,
                            label: 'Delete',
                            color: AppColors.accentRed,
                            onTap: () => _onDeleteTap(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onToggleTap(BuildContext context) async {
    final isActive = employee.active;
    final confirmed = await ConfirmationDialog.show(
      title: isActive ? 'Deactivate Employee' : 'Activate Employee',
      message: isActive
          ? '${employee.name} will be marked Inactive and cannot log meals.'
          : '${employee.name} will be marked Active.',
      confirmLabel: isActive ? 'Deactivate' : 'Activate',
      isDestructive: isActive,
      icon: isActive ? Icons.toggle_off_rounded : Icons.toggle_on_rounded,
      iconColor: isActive ? AppColors.accentAmber : AppColors.accentTeal,
    );
    if (confirmed == true) controller.toggleEmployeeStatus(employee);
  }

  Future<void> _onDeleteTap(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      title: 'Delete Employee',
      message:
      'Are you sure you want to delete "${employee.name}"? This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (confirmed == true) controller.deleteEmployee(employee.id);
  }
}

// ─── Avatar ───────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.employee});
  final EmployeeModel employee;

  @override
  Widget build(BuildContext context) {
    final isActive = employee.active;
    final hasPhoto =
        employee.photoUrl != null && employee.photoUrl!.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                  ? AppColors.green1.withOpacity(0.50)
                  : AppColors.accentRed.withOpacity(0.50),
              width: 2,
            ),
            image: hasPhoto
                ? DecorationImage(
              image: NetworkImage(employee.photoUrl!),
              fit: BoxFit.cover,
            )
                : null,
            gradient: hasPhoto
                ? null
                : LinearGradient(
              colors: isActive
                  ? [AppColors.green1.withOpacity(0.30), AppColors.green2.withOpacity(0.60)]
                  : [AppColors.accentRed.withOpacity(0.20), AppColors.accentRed.withOpacity(0.40)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: hasPhoto
              ? null
              : Center(
            child: Text(
              employee.name.isNotEmpty
                  ? employee.name[0].toUpperCase()
                  : '?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isActive ? AppColors.accentTeal : AppColors.accentRed,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: isActive ? AppColors.accentTeal : AppColors.accentRed,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.bgCard, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Status Chip ──────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.accentTeal : AppColors.accentRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 13, color: Colors.white38),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

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
                fontSize: 12,
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