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
            Text(product.name),
            Text("\$${product.price.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}