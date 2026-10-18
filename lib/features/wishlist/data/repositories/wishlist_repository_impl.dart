import 'package:shopflow/features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:shopflow/features/wishlist/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource dataSource;
  WishlistRepositoryImpl(this.dataSource);

  @override
  Future<List<int>> getWishlistIds() {
    return dataSource.getWishlistIds();
  }

  @override
  Future<void> saveWishlistIds(List<int> ids) {
    return dataSource.saveWishlistIds(ids);
  }
}
