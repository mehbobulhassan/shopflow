import 'package:flutter/material.dart';
import 'package:shopflow/features/products/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
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
              errorBuilder: (context, error, stackTrace) => SizedBox(
                height: 120,
                child: Center(
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.broken_image),
                      Text("Image unavailable"),
                    ],
                  ),
                ),
              ),
            ),
            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
            Text("\$${product.price.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
