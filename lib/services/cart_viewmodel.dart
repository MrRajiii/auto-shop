import 'package:auto_shop/models/cart_item.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart'; // Added this
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart'; // Added this
import '../../../services/cart_service.dart';

class CartViewModel extends ReactiveViewModel {
  final _cartService = locator<CartService>();
  final _navigationService = locator<NavigationService>(); // Added this

  @override
  List<ListenableServiceMixin> get listenableServices => [_cartService];

  List<CartItem> get items => _cartService.items;

  // Change: Use 'totalPrice' to match the View's expectations
  String get totalPrice => _cartService.totalPrice.toStringAsFixed(2);

  // Added: Navigation method for the "Continue Shopping" button
  void navigateToHome() {
    _navigationService.replaceWithHomeView();
  }

  void toggleItemSelection(String productId) {
    _cartService.toggleSelection(productId);
  }

  // Updated: Accept the ID string to match your service logic
  void removeItem(String productId) {
    _cartService.removeItem(productId);
  }

  void clearCart() {
    _cartService.clearCart();
  }

  void checkout() {
    if (items.isNotEmpty) {
      _navigationService.navigateToCheckoutView();
    }
  }
}
