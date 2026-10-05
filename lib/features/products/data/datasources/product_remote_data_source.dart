import 'package:shopflow/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> searchProducts(String query);
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getProductByCategory(String category);
}