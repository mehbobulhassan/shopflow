import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopflow/features/products/presentation/providers/product_providers.dart';

class ProductDebugScreen extends ConsumerWidget {
  const ProductDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Product Debug Screen")),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (products) => Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text("Total Products: ${products.length}"),
              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text("No products available"))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Text(product.name);
                        },
                      ),
              ),
            ],
          ),
        ),
        error: (error, stackTrace) =>
            Center(child: Text("Failed to load products: $error")),
      ),
    );
  }
}
