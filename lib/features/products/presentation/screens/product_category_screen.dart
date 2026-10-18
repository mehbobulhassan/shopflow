import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:shopflow/features/products/presentation/providers/product_providers.dart';
import 'package:shopflow/features/products/presentation/widgets/product_card.dart';

class ProductCategoryScreen extends ConsumerStatefulWidget {
  const ProductCategoryScreen({super.key});

  @override
  ConsumerState<ProductCategoryScreen> createState() =>
      _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends ConsumerState<ProductCategoryScreen> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: productState.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }
          final categories =
              products.map((product) => product.category).toSet().toList()
                ..sort();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (isSelected) {
                        setState(() {
                          selectedCategory = isSelected ? category : null;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: selectedCategory == null
                    ? const Center(
                        child: Text('Select a category to browse products.'),
                      )
                    : Consumer(
                        builder: (context, ref, child) {
                          final categoryState = ref.watch(
                            productCategoryProvider(selectedCategory!),
                          );
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: categoryState.when(
                              data: (categoryProducts) {
                                if (categoryProducts.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'No products found in this category.',
                                    ),
                                  );
                                }

                                return GridView.builder(
                                  itemCount: categoryProducts.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 0.65,
                                      ),
                                  itemBuilder: (context, index) {
                                    final product = categoryProducts[index];

                                    return ProductCard(
                                      product: product,
                                      onTap: () {
                                        context.push('/products/${product.id}');
                                      },
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Failed to load category products.',
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          ref.invalidate(
                                            productCategoryProvider(
                                              selectedCategory!,
                                            ),
                                          );
                                        },
                                        child: const Text('Try Again'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Failed to load categories.'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(productsProvider);
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
