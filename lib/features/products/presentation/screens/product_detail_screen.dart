import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopflow/core/theme/app_spacing.dart';
import 'package:shopflow/core/theme/app_text_styles.dart';
import 'package:shopflow/features/products/presentation/providers/product_providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(productId));
    return Scaffold(
      appBar: AppBar(title: const Text("Product Detail Screen")),
      body: productAsync.when(
        data: (product) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Image.network(
                  product.image,
                  height: 200,
                  fit: BoxFit.contain,
                  loadingBuilder: ((context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }),
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.broken_image_outlined),
                        Text("Failed to load"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs,),
                Text(product.name, style: AppTextStyles.screenTitle,),
                const SizedBox(height: AppSpacing.xs,),
                Text("\$${product.price.toStringAsFixed(2)}", style: AppTextStyles.price,),
                const SizedBox(height: AppSpacing.xs,),
                Text(product.description, style: AppTextStyles.body,)
              ],
            ),
          ),
        ),
        error: (error, stackTrack) => const Center(child: Text("We couldnt load this product. Please try again later.")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
