import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmation')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 88,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Order placed successfully!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Your order has been saved successfully.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.go('/product-debug'),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Continue Shopping'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/orders'),
                  child: const Text('View My Orders'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
