import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopflow/features/cart/domain/entities/cart_item.dart';
import 'package:shopflow/features/cart/presentation/providers/cart_provider.dart';
import 'package:shopflow/features/products/presentation/providers/product_providers.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  Future<void> _handleCartMutation(
    BuildContext context,
    Future<void> Function() mutation,
  ) async {
    try {
      await mutation();
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Couldn't update your cart. Please try again."),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productByIdProvider(item.productId));

    return productState.when(
      loading: () => const ListTile(
        leading: SizedBox(
          width: 40,
          height: 40,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        title: Text('Loading product...'),
      ),
      error: (error, stackTrace) => const ListTile(
        leading: Icon(Icons.error_outline),
        title: Text("Couldn't load product details"),
      ),
      data: (product) {
        final cartNotifier = ref.read(cartProvider.notifier);

        return ListTile(
          leading: Image.network(
            product.image,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                width: 60,
                height: 60,
                child: Icon(Icons.image_not_supported_outlined),
              );
            },
          ),
          title: Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('\$${product.price.toStringAsFixed(2)}'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Decrease quantity',
                    onPressed: () {
                      _handleCartMutation(
                        context,
                        () => cartNotifier.updateQuantity(
                          item.productId,
                          item.quantity - 1,
                        ),
                      );
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text('${item.quantity}'),
                  IconButton(
                    tooltip: 'Increase quantity',
                    onPressed: () {
                      _handleCartMutation(
                        context,
                        () => cartNotifier.addToCart(item.productId),
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    tooltip: 'Remove item',
                    onPressed: () {
                      _handleCartMutation(
                        context,
                        () => cartNotifier.removeFromCart(item.productId),
                      );
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ],
          ),
          isThreeLine: true,
        );
      },
    );
  }
}
