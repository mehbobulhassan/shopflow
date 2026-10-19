import 'package:shopflow/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:shopflow/features/cart/data/models/cart_item_model.dart';
import 'package:shopflow/features/cart/domain/entities/cart_item.dart';
import 'package:shopflow/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource dataSource;

  CartRepositoryImpl(this.dataSource);

  @override
  Future<List<CartItem>> getCartItems() async {
    final models = await dataSource.getCartItems();

    return models
        .map(
          (model) =>
              CartItem(productId: model.productId, quantity: model.quantity),
        )
        .toList();
  }

  @override
  Future<void> saveCartItems(List<CartItem> items) async {
    final models = items
        .map(
          (item) =>
              CartItemModel(productId: item.productId, quantity: item.quantity),
        )
        .toList();

    await dataSource.saveCartItems(models);
  }
}
