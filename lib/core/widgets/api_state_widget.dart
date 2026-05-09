import 'package:flutter/material.dart';

/// ApiStateWidget — single widget that handles the 4 states of any API-driven list:
///   loading → show skeleton spinner
///   error   → show error card with retry button
///   empty   → show empty illustration + message
///   data    → render child
///
/// Usage:
///   ApiStateWidget(
///     isLoading: controller.isLoading.value,
///     errorMessage: controller.errorMessage.value,
///     isEmpty: controller.employees.isEmpty,
///     onRetry: controller.loadEmployees,
///     emptyTitle: 'No Employees Found',
///     emptySubtitle: 'Tap + to add the first employee.',
///     child: ListView.builder(...),
///   )
class ApiStateWidget extends StatelessWidget {
  const ApiStateWidget({
    super.key,
    required this.isLoading,
    required this.child,
    this.errorMessage,
    this.isEmpty = false,
    this.onRetry,
    this.emptyTitle = 'Nothing here yet',
    this.emptySubtitle,
    this.emptyIcon = Icons.inbox_outlined,
    this.loadingWidget,
  });

  final bool isLoading;
  final Widget child;
  final String? errorMessage;
  final bool isEmpty;
  final VoidCallback? onRetry;
  final String emptyTitle;
  final String? emptySubtitle;
  final IconData emptyIcon;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    // 1. Loading
    if (isLoading) {
      return loadingWidget ?? const _DefaultLoader();
    }

    // 2. Error
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return _ErrorView(message: errorMessage!, onRetry: onRetry);
    }

    // 3. Empty
    if (isEmpty) {
      return _EmptyView(
        title: emptyTitle,
        subtitle: emptySubtitle,
        icon: emptyIcon,
      );
    }

    // 4. Data
    return child;
  }
}

// ─── Loading ─────────────────────────────────────────────────────────────────

class _DefaultLoader extends StatelessWidget {
  const _DefaultLoader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

// ─── Error ────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Empty ────────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.title,
    this.subtitle,
    required this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
