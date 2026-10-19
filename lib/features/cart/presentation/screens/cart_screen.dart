import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:shopflow/features/cart/presentation/providers/cart_provider.dart';
import 'package:shopflow/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:shopflow/features/products/presentation/providers/product_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cartState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Text('Could not load your cart. Please try again.'),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          final totalQuantity = items.fold<int>(
            0,
            (total, item) => total + item.quantity,
          );

          // Watch every product request so the summary rebuilds
          // when any product finishes loading or fails.
          final productStates = items
              .map((item) => ref.watch(productByIdProvider(item.productId)))
              .toList();

          final hasError = productStates.any((state) => state.hasError);

          final isLoading = productStates.any((state) => state.isLoading);

          double? subtotal;

          if (!hasError && !isLoading) {
            var calculatedSubtotal = 0.0;

            for (var i = 0; i < items.length; i++) {
              final product = productStates[i].requireValue;

              calculatedSubtotal += product.price * items[i].quantity;
            }

            subtotal = calculatedSubtotal;
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return CartItemTile(item: items[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total items: $totalQuantity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (hasError)
                      Text(
                        'Subtotal unavailable',
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    else if (isLoading)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Calculating subtotal…',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      )
                    else
                      Text(
                        'Subtotal: \$${subtotal!.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: FilledButton(
                  onPressed: () {
                    context.push('/checkout');
                  },
                  child: const Text('Proceed to Checkout'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
