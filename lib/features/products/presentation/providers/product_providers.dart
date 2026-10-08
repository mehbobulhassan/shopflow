
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopflow/features/products/data/datasources/product_remote_data_source.dart';
import 'package:shopflow/features/products/data/datasources/product_remote_data_source_impl.dart';
import 'package:shopflow/features/products/data/repositories/product_repository_impl.dart';
import 'package:shopflow/features/products/domain/repositories/product_repository.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSourceImpl();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(dataSource);
});


