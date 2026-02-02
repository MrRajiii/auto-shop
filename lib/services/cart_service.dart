import 'package:auto_shop/models/cart_item.dart';
import 'package:stacked/stacked.dart';
import '../models/product_model.dart'; // Import the new model

class CartService with ListenableServiceMixin {
  // Change list type from Product to CartItem
  final ReactiveList<CartItem> _items = ReactiveList<CartItem>();
  List<CartItem> get items => _items;

  CartService() {
    listenToReactiveValues([_items]);
  }

  void toggleSelection(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  void addToCart(Product product, int quantity) {
    // Look for the product within our CartItems
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // If it exists, just update the quantity
      _items[index].quantity += quantity;
    } else {
      // If new, add a new CartItem
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) {
      if (!item.isSelected) return sum; // Skip if not checked
      double price = double.parse(item.product.price.replaceAll(',', ''));
      return sum + (price * item.quantity);
    });
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
