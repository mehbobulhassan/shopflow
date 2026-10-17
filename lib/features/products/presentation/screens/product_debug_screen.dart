import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopflow/features/products/presentation/providers/product_providers.dart';
import 'package:shopflow/features/products/presentation/widgets/product_card.dart';

class ProductDebugScreen extends ConsumerWidget {
  const ProductDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Debug Screen"),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/search');
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Browse categories',
            onPressed: () {
              context.push('/categories');
            },
          ),
        ],
      ),
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
                    : GridView.builder(
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              context.push('/products/${product.id}');
                            },
                          );
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
