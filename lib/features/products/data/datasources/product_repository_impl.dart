import 'package:shopflow/features/products/data/datasources/product_remote_data_source.dart';
import 'package:shopflow/features/products/domain/entities/product.dart';
import 'package:shopflow/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
final ProductRemoteDataSource dataSource;

ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> getProductByCategory(String category) async {
    final products = await dataSource.getProductByCategory(category);
    return products.map((item) => item.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    final product = await dataSource.getProductById(id);
    return product.toEntity();
  }

  @override
  Future<List<Product>> getProducts() async {
    final products = await dataSource.getProducts();
    return products.map((item) => item.toEntity()).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final products = await dataSource.searchProducts(query);
    return products.map((item) => item.toEntity()).toList();
  }
}
