import 'package:flutter/material.dart';

/// Column definition for CommonTable.
class TableColumn<T> {
  const TableColumn({
    required this.label,
    required this.cellBuilder,
    this.flex = 1,
    this.minWidth,
    this.alignment = Alignment.centerLeft,
    this.sortKey,
  });

  final String label;
  final Widget Function(T item) cellBuilder;
  final int flex;
  final double? minWidth;
  final Alignment alignment;

  /// If non-null the column header becomes tappable for sorting.
  final String? sortKey;
}

/// CommonTable — responsive data table built with ListView for infinite scroll.
///
/// Usage:
///   CommonTable<EmployeeModel>(
///     columns: [
///       TableColumn(label: 'Name', cellBuilder: (e) => Text(e.name), flex: 2),
///       TableColumn(label: 'Code', cellBuilder: (e) => Text(e.employeeCode)),
///     ],
///     rows: controller.employees,
///     onRowTap: (e) => Get.to(() => EditEmployeeScreen(employee: e)),
///   )
class CommonTable<T> extends StatelessWidget {
  const CommonTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
    this.onRowLongPress,
    this.rowHeight = 52.0,
    this.headerHeight = 48.0,
    this.showRowDivider = true,
    this.striped = true,
    this.sortColumnKey,
    this.sortAscending = true,
    this.onSort,
    this.emptyMessage = 'No data available',
  });

  final List<TableColumn<T>> columns;
  final List<T> rows;
  final void Function(T item)? onRowTap;
  final void Function(T item)? onRowLongPress;
  final double rowHeight;
  final double headerHeight;
  final bool showRowDivider;
  final bool striped;
  final String? sortColumnKey;
  final bool sortAscending;
  final void Function(String key, bool ascending)? onSort;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Container(
          height: headerHeight,
          color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
          child: Row(
            children: columns.map((col) {
              final isSorted = col.sortKey != null &&
                  col.sortKey == sortColumnKey;
              return Expanded(
                flex: col.flex,
                child: InkWell(
                  onTap: col.sortKey != null && onSort != null
                      ? () => onSort!(
                            col.sortKey!,
                            isSorted ? !sortAscending : true,
                          )
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            col.label,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSorted)
                          Icon(
                            sortAscending
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const Divider(height: 1),

        // ── Rows ─────────────────────────────────────────────────────────────
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                emptyMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: rows.length,
              separatorBuilder: (_, __) =>
                  showRowDivider ? const Divider(height: 1) : const SizedBox(),
              itemBuilder: (context, index) {
                final item = rows[index];
                final isEven = index.isEven;

                return InkWell(
                  onTap: onRowTap != null ? () => onRowTap!(item) : null,
                  onLongPress: onRowLongPress != null
                      ? () => onRowLongPress!(item)
                      : null,
                  child: Container(
                    height: rowHeight,
                    color: striped && isEven
                        ? theme.colorScheme.surfaceVariant.withOpacity(0.2)
                        : null,
                    child: Row(
                      children: columns.map((col) {
                        return Expanded(
                          flex: col.flex,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Align(
                              alignment: col.alignment,
                              child: col.cellBuilder(item),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
