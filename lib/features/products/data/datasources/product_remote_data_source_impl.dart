import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopflow/features/products/data/datasources/product_remote_data_source.dart';
import 'package:shopflow/features/products/data/models/product_model.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    final url = Uri.parse("https://fakestoreapi.com/products");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        jsonDecode(response.body),
      );
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception(
        "Failed to load products. Status code: ${response.statusCode}",
      );
    }
  }

  @override
  Future<List<ProductModel>> getProductByCategory(String category) async {
    final url = Uri.parse(
      "https://fakestoreapi.com/products/category/$category",
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        jsonDecode(response.body),
      );
      return data.map((item) => ProductModel.fromJson(item)).toList();
      
    } else {
      throw Exception(
        "Failed to load products. Status code: ${response.statusCode} ",
      );
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final url = Uri.parse("https://fakestoreapi.com/products/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        "Failed to load product. Status code: ${response.statusCode}",
      );
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final url = Uri.parse("https://fakestoreapi.com/products");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        jsonDecode(response.body),
      );
      final products = data.map((item) => ProductModel.fromJson(item)).toList();
      if (query.trim().isEmpty) {
        return products;
      }
      final searchQuery = query.trim().toLowerCase();
      return products
          .where(
            (item) => item.title.trim().toLowerCase().contains(searchQuery),
          )
          .toList();
    } else {
      throw Exception(
        "Failed to load products. Status code: ${response.statusCode}",
      );
    }
  }
}
