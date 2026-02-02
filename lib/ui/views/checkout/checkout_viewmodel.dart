import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/cart_service.dart';
import '../../../services/authentication_service.dart';

class CheckoutViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _cartService = locator<CartService>();
  final _authService = locator<AuthenticationService>();

  String get totalPrice => _cartService.totalPrice.toStringAsFixed(2);

  String get userAddress =>
      _authService.currentUser?.address ?? "No address provided";

  Future<void> processOrder() async {
    setBusy(true);

    try {
      final user = _authService.currentUser;

      // Filter for items that are marked as isSelected
      final selectedItems =
          _cartService.items.where((item) => item.isSelected).toList();

      if (selectedItems.isEmpty) {
        // You might want to show a dialog here: "No items selected"
        setBusy(false);
        return;
      }

      // 1. Prepare the Order Data for your Shopee manual ordering
      final orderData = {
        'userId': user?.id,
        'customerName': user?.fullName,
        'customerEmail': user?.email,
        'customerAddress': user?.address,
        'totalAmount': _cartService.totalPrice,
        'status': 'PENDING', // Statuses: PENDING -> ORDERED_ON_SHOPEE -> READY
        'createdAt': FieldValue.serverTimestamp(),
        'items': selectedItems
            .map((item) => {
                  'productId': item.product.id,
                  'name': item.product.name, // Accessing via item.product
                  'price': item.product.price, // Accessing via item.product
                  'quantity': item.quantity,
                })
            .toList(),
      };

      // 2. Save to Firestore 'orders' collection
      await FirebaseFirestore.instance.collection('orders').add(orderData);

      // 3. Clear the cart via the service
      _cartService.clearCart();

      // 4. Navigate to Success
      _navigationService.clearStackAndShow(Routes.orderSuccessView);
    } catch (e) {
      print("Error placing order: $e");
      // Handle error (maybe show a dialog)
    } finally {
      setBusy(false);
    }
  }

  void goBack() {
    _navigationService.back();
  }
}
