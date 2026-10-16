
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopflow/features/products/presentation/providers/product_providers.dart';
import 'package:shopflow/features/products/presentation/widgets/product_card.dart';

class ProductSearchScreen extends ConsumerStatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ConsumerState<ProductSearchScreen> createState() =>
      _ProductSearchScreenState();
}

class _ProductSearchScreenState
    extends ConsumerState<ProductSearchScreen> {
  final TextEditingController searchQuery = TextEditingController();

  String query = '';

  void _submitSearch(String value) {
    FocusScope.of(context).unfocus();

    setState(() {
      query = value.trim();
    });
  }

  void _clearSearch() {
    searchQuery.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      query = '';
    });
  }

  @override
  void dispose() {
    searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(productSearchProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchQuery,
              textInputAction: TextInputAction.search,
              onSubmitted: _submitSearch,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for products...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearSearch,
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submitSearch(searchQuery.text),
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: query.isEmpty
                  ? const Center(
                      child: Text('Search for a product to get started.'),
                    )
                  : searchState.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Failed to load products.'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                ref.invalidate(productSearchProvider(query));
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                      data: (products) {
                        if (products.isEmpty) {
                          return const Center(
                            child: Text('No products found. Try a different search.'),
                          );
                        }
                        return GridView.builder(
                          itemCount: products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.65
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
