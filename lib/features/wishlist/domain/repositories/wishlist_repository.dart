abstract class WishlistRepository {
  Future<List<int>> getWishlistIds();
  Future<void> saveWishlistIds(List<int> ids);
}
