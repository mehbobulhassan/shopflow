import 'package:shopflow/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> searchProducts(String query);
  Future<Product> getProductById(int id);
  Future<List<Product>> getProductByCategory(String category);
}