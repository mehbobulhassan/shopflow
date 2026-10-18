import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopflow/core/theme/app_colors.dart';
import 'package:shopflow/core/theme/app_spacing.dart';
import 'package:shopflow/core/theme/app_text_styles.dart';
import 'package:shopflow/features/products/domain/entities/product.dart';
import 'package:shopflow/features/wishlist/presentation/providers/wishlist_provider.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final wishlistState = ref.watch(wishlistProvider);

    final savedIds = wishlistState.asData?.value;
    final isSaved = savedIds?.contains(product.id) ?? false;

    // Do not allow changes until the wishlist has loaded successfully.
    final canUpdateWishlist = savedIds != null;

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 1,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Center(
                    child: Image.network(
                      product.image,
                      height: 120,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 120,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.broken_image),
                                Text('Image unavailable'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // The heart button overlays the image.
                  IconButton.filledTonal(
                    tooltip: !canUpdateWishlist
                        ? (wishlistState.hasError
                              ? 'Wishlist unavailable'
                              : 'Loading wishlist')
                        : isSaved
                        ? 'Remove from wishlist'
                        : 'Add to wishlist',
                    onPressed: !canUpdateWishlist
                        ? null
                        : () async {
                            try {
                              final notifier = ref.read(
                                wishlistProvider.notifier,
                              );

                              if (isSaved) {
                                await notifier.removeFromWishlist(product.id);
                              } else {
                                await notifier.addToWishlist(product.id);
                              }
                            } catch (error) {
                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not update wishlist. Please try again.',
                                    ),
                                  ),
                                );
                            }
                          },
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved
                          ? AppColors.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: AppTextStyles.price,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
