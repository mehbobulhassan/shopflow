import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopflow/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:shopflow/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopflow/features/cart/domain/entities/cart_item.dart';
import 'package:shopflow/features/cart/domain/repositories/cart_repository.dart';

final cartLocalDataSourceProvider = Provider<CartLocalDataSource>((ref) {
  return CartLocalDataSource();
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final dataSource = ref.watch(cartLocalDataSourceProvider);
  return CartRepositoryImpl(dataSource);
});

final cartProvider = AsyncNotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

class CartNotifier extends AsyncNotifier<List<CartItem>> {
  Future<void> _mutationQueue = Future<void>.value();

  @override
  Future<List<CartItem>> build() async {
    final repository = ref.read(cartRepositoryProvider);
    return repository.getCartItems();
  }

  Future<void> _serializeMutation(Future<void> Function() operation) {
    final result = _mutationQueue.then((_) => operation());

    // Keep the queue usable even if this operation fails.
    _mutationQueue = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );

    return result;
  }

  Future<void> addToCart(int productId) {
    return _serializeMutation(() async {
      final currentItems = state.asData?.value;
      if (currentItems == null) return;

      final existingIndex = currentItems.indexWhere(
        (item) => item.productId == productId,
      );

      final List<CartItem> updatedItems;

      if (existingIndex != -1) {
        updatedItems = currentItems.map((item) {
          if (item.productId == productId) {
            return CartItem(
              productId: item.productId,
              quantity: item.quantity + 1,
            );
          }
          return item;
        }).toList();
      } else {
        updatedItems = [
          ...currentItems,
          CartItem(productId: productId, quantity: 1),
        ];
      }

      await _saveAndUpdate(updatedItems);
    });
  }

  Future<void> removeFromCart(int productId) {
    return _serializeMutation(() async {
      final currentItems = state.asData?.value;
      if (currentItems == null) return;

      final updatedItems = currentItems
          .where((item) => item.productId != productId)
          .toList();

      if (updatedItems.length == currentItems.length) return;

      await _saveAndUpdate(updatedItems);
    });
  }

  Future<void> updateQuantity(int productId, int quantity) {
    return _serializeMutation(() async {
      final currentItems = state.asData?.value;
      if (currentItems == null) return;

      final itemExists = currentItems.any(
        (item) => item.productId == productId,
      );

      if (!itemExists) return;

      final List<CartItem> updatedItems;

      if (quantity <= 0) {
        // Remove directly within this queued operation.
        updatedItems = currentItems
            .where((item) => item.productId != productId)
            .toList();
      } else {
        updatedItems = currentItems.map((item) {
          if (item.productId == productId) {
            return CartItem(productId: item.productId, quantity: quantity);
          }
          return item;
        }).toList();
      }

      await _saveAndUpdate(updatedItems);
    });
  }

  int getTotalQuantity() {
    final currentItems = state.asData?.value;
    if (currentItems == null) return 0;

    return currentItems.fold(0, (total, item) => total + item.quantity);
  }

  Future<void> _saveAndUpdate(List<CartItem> updatedItems) async {
    final repository = ref.read(cartRepositoryProvider);

    // Persist first; update state only after a successful save.
    await repository.saveCartItems(updatedItems);

    state = AsyncData(updatedItems);
  }
}
