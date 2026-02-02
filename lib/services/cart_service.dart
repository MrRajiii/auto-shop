import 'package:auto_shop/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import '../models/product_model.dart';

class CartService with ListenableServiceMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ReactiveList<CartItem> _items = ReactiveList<CartItem>();
  List<CartItem> get items => _items;

  CartService() {
    listenToReactiveValues([_items]);
  }

  void loadCart(List<CartItem> savedItems) {
    _items.clear();
    _items.addAll(savedItems);
    notifyListeners();
  }

  void toggleSelection(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  Future<void> addToCart(Product product, int quantity,
      {String? userId}) async {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }

    if (userId != null) {
      await syncToFirestore(userId);
    }
    notifyListeners();
  }

  Future<void> removeItem(String productId, {String? userId}) async {
    _items.removeWhere((item) => item.product.id == productId);
    if (userId != null) {
      await syncToFirestore(userId);
    }
    notifyListeners();
  }

  // Updated to include 'specifications' and 'description' to match AuthService requirements
  Future<void> syncToFirestore(String userId) async {
    try {
      final cartData = _items
          .map((item) => {
                'productId': item.product.id,
                'name': item.product.name,
                'price': item.product.price,
                'quantity': item.quantity,
                'imageUrl': item.product.imageUrls.isNotEmpty
                    ? item.product.imageUrls.first
                    : 'https://via.placeholder.com/150', // Fallback for 404 images
                'category': item.product.category,
                'description': item.product.description,
                'specifications': item.product.specifications,
                'isSelected': item.isSelected,
              })
          .toList();

      await _firestore.collection('carts').doc(userId).set({
        'items': cartData,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error syncing cart: $e");
    }
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) {
      if (!item.isSelected) return sum;
      double price =
          double.tryParse(item.product.price.replaceAll(',', '')) ?? 0;
      return sum + (price * item.quantity);
    });
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
