import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopflow/core/theme/app_colors.dart';

import 'package:shopflow/features/products/domain/entities/product.dart';
import 'package:shopflow/features/products/presentation/providers/product_providers.dart';
import 'package:shopflow/features/products/presentation/widgets/product_card.dart';
import 'package:shopflow/features/wishlist/presentation/providers/wishlist_provider.dart';

final wishlistProductsProvider = FutureProvider.family<List<Product>, String>((
  ref,
  idsKey,
) async {
  final repository = ref.watch(productRepositoryProvider);

  if (idsKey.isEmpty) {
    return [];
  }

  final ids = idsKey.split(',').map(int.parse).toList();

  final results = await Future.wait(
    ids.map((id) async {
      try {
        return await repository.getProductById(id);
      } catch (_) {
        // One unavailable product should not hide the others.
        return null;
      }
    }),
  );

  return results.whereType<Product>().toList();
});

class ProductWishlistScreen extends ConsumerWidget {
  const ProductWishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistState = ref.watch(wishlistProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: wishlistState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _MessageState(
          icon: Icons.error_outline,
          title: 'Could not load your wishlist',
          message: 'Please try again.',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(wishlistProvider),
        ),
        data: (savedIds) {
          if (savedIds.isEmpty) {
            return const _EmptyWishlist();
          }

          final idsKey = savedIds.join(',');
          final productsState = ref.watch(wishlistProductsProvider(idsKey));

          return productsState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => _MessageState(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load products',
              message: 'Check your connection and try again.',
              actionLabel: 'Retry',
              onAction: () {
                ref.invalidate(wishlistProductsProvider(idsKey));
              },
            ),
            data: (products) {
              if (products.isEmpty) {
                return _MessageState(
                  icon: Icons.inventory_2_outlined,
                  title: 'Products unavailable',
                  message:
                      'Your saved IDs exist, but their products could '
                      'not be retrieved.',
                  actionLabel: 'Clear wishlist',
                  onAction: () async {
                    try {
                      final notifier = ref.read(wishlistProvider.notifier);

                      for (final id in [...savedIds]) {
                        await notifier.removeFromWishlist(id);
                      }

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(content: Text('Wishlist cleared')),
                        );
                    } catch (error) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not clear wishlist. Please try again.',
                            ),
                          ),
                        );
                    }
                  },
                );
              }

              final availableIds = products
                  .map((product) => product.id)
                  .toSet();

              final unavailableIds = savedIds
                  .where((id) => !availableIds.contains(id))
                  .toList();

              return RefreshIndicator(
                onRefresh: () async {
                  final productsFuture = ref.refresh(
                    wishlistProductsProvider(idsKey).future,
                  );

                  await productsFuture;
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Saved products (${products.length})',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ...products.map(
                      (product) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Stack(
                          children: [
                            ProductCard(
                              product: product,
                              onTap: () {
                                context.push('/products/${product.id}');
                              },
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton.filledTonal(
                                tooltip: 'Remove from wishlist',
                                onPressed: () async {
                                  try {
                                    await ref
                                        .read(wishlistProvider.notifier)
                                        .removeFromWishlist(product.id);

                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Removed from wishlist',
                                          ),
                                        ),
                                      );
                                  } catch (error) {
                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Could not remove product. Please try again.',
                                          ),
                                        ),
                                      );
                                  }
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (unavailableIds.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${unavailableIds.length} saved product(s) '
                        'could not be loaded.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            final notifier = ref.read(
                              wishlistProvider.notifier,
                            );

                            for (final id in unavailableIds) {
                              await notifier.removeFromWishlist(id);
                            }

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Unavailable products removed'),
                                ),
                              );
                          } catch (error) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Could not remove all unavailable products. Please try again.',
                                  ),
                                ),
                              );
                          }
                        },
                        child: const Text('Remove unavailable products'),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Your wishlist is empty',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Save products you like and they will appear here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
