import 'package:go_router/go_router.dart';
import 'package:shopflow/features/cart/domain/entities/cart_item.dart';
import 'package:shopflow/features/products/domain/entities/product.dart';
import 'package:shopflow/features/orders/domain/entities/order.dart';
import 'package:shopflow/features/orders/domain/entities/order_item.dart';
import 'package:shopflow/features/orders/presentation/providers/order_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopflow/features/cart/presentation/providers/cart_provider.dart';
import 'package:shopflow/features/products/presentation/providers/product_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isPlacingOrder = false;

  Future<void> _placeOrder({
    required List<CartItem> items,
    required List<Product> products,
    required double total,
  }) async {
    if (_isPlacingOrder) return;

    setState(() => _isPlacingOrder = true);

    try {
      final order = Order(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        items: List.generate(
          items.length,
          (index) => OrderItem(
            productId: products[index].id,
            productName: products[index].name,
            unitPrice: products[index].price,
            quantity: items[index].quantity,
            image: products[index].image,
          ),
        ),
        totalAmount: total,
        createdAt: DateTime.now(),
        status: 'Placed',
      );

      // Ensure the order history has loaded before updating it.
      await ref.read(ordersProvider.future);

      // Save the order before clearing the cart.
      await ref.read(ordersProvider.notifier).placeOrder(order);
      await ref.read(cartProvider.notifier).clearCart();

      if (!mounted) return;
      context.go('/order-confirmation');
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to complete checkout. Please check your order status before trying again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: cartState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Text('Failed to load your cart. Please try again.'),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Your cart is empty. Add products before checking out.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

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
          final products = !hasError && !isLoading
              ? productStates.map((state) => state.requireValue).toList()
              : <Product>[];

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final productState = productStates[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: productState.when(
                          loading: () => const SizedBox(
                            height: 60,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (error, stackTrace) => Text(
                            'Failed to load product #${item.productId}.',
                          ),

                          data: (product) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Unit price: \$${product.price.toStringAsFixed(2)}',
                                    ),
                                    Text('Quantity: ${item.quantity}'),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Item total: \$${(product.price * item.quantity).toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isLoading)
                      const Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Calculating subtotal...'),
                        ],
                      )
                    else if (hasError)
                      Text(
                        'Subtotal unavailable. Some products could not be loaded.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    else
                      Text(
                        'Subtotal: \$${subtotal!.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed:
                          _isPlacingOrder ||
                              hasError ||
                              isLoading ||
                              subtotal == null
                          ? null
                          : () => _placeOrder(
                              items: items,
                              products: products,
                              total: subtotal!,
                            ),
                      child: _isPlacingOrder
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Place Order'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
