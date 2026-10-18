import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopflow/features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:shopflow/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:shopflow/features/wishlist/domain/repositories/wishlist_repository.dart';

final wishlistLocalDataSourceProvider = Provider<WishlistLocalDataSource>((
  ref,
) {
  return WishlistLocalDataSource();
});

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final dataSource = ref.watch(wishlistLocalDataSourceProvider);

  return WishlistRepositoryImpl(dataSource);
});

final wishlistProvider = AsyncNotifierProvider<WishlistNotifier, List<int>>(
  WishlistNotifier.new,
);

class WishlistNotifier extends AsyncNotifier<List<int>> {
  Future<void> _mutationQueue = Future<void>.value();

  @override
  Future<List<int>> build() async {
    final repository = ref.read(wishlistRepositoryProvider);
    return repository.getWishlistIds();
  }

  Future<void> addToWishlist(int productId) {
    return _serializeMutation(() async {
      final currentIds = state.asData?.value;

      if (currentIds == null || currentIds.contains(productId)) {
        return;
      }

      final updatedIds = [...currentIds, productId];

      await ref.read(wishlistRepositoryProvider).saveWishlistIds(updatedIds);

      state = AsyncData(updatedIds);
    });
  }

  Future<void> removeFromWishlist(int productId) {
    return _serializeMutation(() async {
      final currentIds = state.asData?.value;

      if (currentIds == null || !currentIds.contains(productId)) {
        return;
      }

      final updatedIds = currentIds.where((id) => id != productId).toList();

      await ref.read(wishlistRepositoryProvider).saveWishlistIds(updatedIds);

      state = AsyncData(updatedIds);
    });
  }

  bool isInWishlist(int productId) {
    return state.asData?.value.contains(productId) ?? false;
  }

  Future<void> _serializeMutation(Future<void> Function() operation) {
    final result = _mutationQueue.then((_) => operation());

    // Keep the queue usable after a failed operation, while allowing
    // the original result to propagate its error to the caller.
    _mutationQueue = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );

    return result;
  }
}
