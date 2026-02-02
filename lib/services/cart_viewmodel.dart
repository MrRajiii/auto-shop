import 'package:auto_shop/models/cart_item.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/cart_service.dart';

class CartViewModel extends ReactiveViewModel {
  final _cartService = locator<CartService>();
  final _navigationService = locator<NavigationService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_cartService];

  List<CartItem> get items => _cartService.items;

  /// Calculate total price ONLY for selected items
  String get totalPrice {
    double total = 0;
    for (var item in items) {
      if (item.isSelected) {
        // Remove commas from price string if they exist (e.g. "1,200") to avoid parsing errors
        double price =
            double.tryParse(item.product.price.replaceAll(',', '')) ?? 0;
        total += price * item.quantity;
      }
    }
    return total.toStringAsFixed(2);
  }

  /// Navigation for the "Continue Shopping" button
  void navigateToHome() {
    _navigationService.replaceWithHomeView();
  }

  void toggleItemSelection(String productId) {
    _cartService.toggleSelection(productId);
    // We notify listeners to ensure the Order Summary (totalPrice) updates immediately
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartService.removeItem(productId);
  }

  void clearCart() {
    _cartService.clearCart();
  }

  /// Updated: Only navigate to checkout if at least one item is selected
  void checkout() {
    final hasSelectedItems = items.any((item) => item.isSelected);

    if (hasSelectedItems) {
      _navigationService.navigateToCheckoutView();
    } else {
      // You could optionally trigger a DialogService here to tell the user:
      // "Please select at least one item to checkout."
    }
  }

  /// Updated: Update quantity via the service to ensure persistence
  void updateItemQuantity(CartItem item, int newQuantity) {
    if (newQuantity < 1) return;

    // Direct update for immediate UI snappiness
    item.quantity = newQuantity;
    notifyListeners();

    // Sync with the CartService to ensure the quantity is saved (Firestore/Local)
    _cartService.updateQuantity(item.product.id, newQuantity);
  }
}
