import 'package:flutter/material.dart';

/// PaginationWidget — compact page-navigation bar for server-side pagination.
///
/// Usage:
///   PaginationWidget(
///     currentPage: controller.currentPage.value,   // 0-based
///     totalPages: controller.totalPages.value,
///     onPageChanged: controller.goToPage,
///   )
class PaginationWidget extends StatelessWidget {
  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.showPageInfo = true,
  });

  /// 0-based current page index.
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final bool showPageInfo;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final canPrev = currentPage > 0;
    final canNext = currentPage < totalPages - 1;

    // Visible page buttons — show at most 5 around current page
    final pageButtons = _buildPageNumbers();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First
          _NavButton(
            icon: Icons.first_page_rounded,
            enabled: canPrev,
            tooltip: 'First page',
            onTap: () => onPageChanged(0),
          ),
          const SizedBox(width: 4),

          // Prev
          _NavButton(
            icon: Icons.chevron_left_rounded,
            enabled: canPrev,
            tooltip: 'Previous page',
            onTap: () => onPageChanged(currentPage - 1),
          ),
          const SizedBox(width: 8),

          // Page number buttons
          ...pageButtons.map(
            (page) => page == -1
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '…',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : _PageButton(
                    page: page,
                    isActive: page == currentPage,
                    onTap: () => onPageChanged(page),
                  ),
          ),

          const SizedBox(width: 8),

          // Next
          _NavButton(
            icon: Icons.chevron_right_rounded,
            enabled: canNext,
            tooltip: 'Next page',
            onTap: () => onPageChanged(currentPage + 1),
          ),
          const SizedBox(width: 4),

          // Last
          _NavButton(
            icon: Icons.last_page_rounded,
            enabled: canNext,
            tooltip: 'Last page',
            onTap: () => onPageChanged(totalPages - 1),
          ),

          if (showPageInfo) ...[
            const SizedBox(width: 12),
            Text(
              'Page ${currentPage + 1} of $totalPages',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Returns list of page indices to show; -1 means ellipsis.
  List<int> _buildPageNumbers() {
    if (totalPages <= 7) {
      return List.generate(totalPages, (i) => i);
    }

    final pages = <int>[];
    pages.add(0); // always first

    if (currentPage > 3) pages.add(-1); // left ellipsis

    for (int i = (currentPage - 1).clamp(1, totalPages - 2);
        i <= (currentPage + 1).clamp(1, totalPages - 2);
        i++) {
      pages.add(i);
    }

    if (currentPage < totalPages - 4) pages.add(-1); // right ellipsis

    pages.add(totalPages - 1); // always last

    return pages;
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: enabled
                  ? theme.colorScheme.outlineVariant
                  : theme.colorScheme.outlineVariant.withOpacity(0.3),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: enabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.page,
    required this.isActive,
    required this.onTap,
  });

  final int page;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? null
              : Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Center(
          child: Text(
            '${page + 1}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
