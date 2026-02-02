import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:auto_shop/models/cart_item.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/cart_service.dart';
import '../../../services/authentication_service.dart';

class CheckoutViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _cartService = locator<CartService>();
  final _authService = locator<AuthenticationService>();

  // Temporary state for form fields
  String _customerName = '';
  String _phoneNumber = '';
  String _shippingAddress = '';

  // Validation flag
  bool _showValidationErrors = false;
  bool get showValidationErrors => _showValidationErrors;

  // Getters for form values
  String get customerName => _customerName;
  String get phoneNumber => _phoneNumber;
  String get shippingAddress => _shippingAddress;

  // Validation Checkers
  bool get isNameValid => _customerName.trim().isNotEmpty;
  bool get isPhoneValid =>
      _phoneNumber.trim().length >= 10; // Basic check for PH numbers
  bool get isAddressValid => _shippingAddress.trim().isNotEmpty;

  // Getters to show data in the UI
  List<CartItem> get selectedItems =>
      _cartService.items.where((item) => item.isSelected).toList();

  // Calculate total only for selected items
  String get totalPrice {
    double total = 0;
    for (var item in selectedItems) {
      double price =
          double.tryParse(item.product.price.replaceAll(',', '')) ?? 0;
      total += price * item.quantity;
    }
    return total.toStringAsFixed(2);
  }

  // Setters to update state from the View
  void updateName(String value) {
    _customerName = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void updateAddress(String value) {
    _shippingAddress = value;
    notifyListeners();
  }

  Future<void> processOrder() async {
    // 1. Enable validation visibility
    _showValidationErrors = true;
    notifyListeners();

    // 2. Comprehensive Validation Check
    if (selectedItems.isEmpty) return;

    if (!isNameValid || !isPhoneValid || !isAddressValid) {
      // Form is incomplete; stop here. The UI will now show red errors.
      return;
    }

    setBusy(true);

    try {
      final user = _authService.currentUser;

      // 3. Prepare Order Data
      final orderData = {
        'userId': user?.id,
        'customerName': _customerName.trim(),
        'customerPhone': _phoneNumber.trim(),
        'customerEmail': user?.email,
        'customerAddress': _shippingAddress.trim(),
        'totalAmount': double.parse(totalPrice),
        'status': 'PENDING',
        'createdAt': FieldValue.serverTimestamp(),
        'items': selectedItems
            .map((item) => {
                  'productId': item.product.id,
                  'name': item.product.name,
                  'price': item.product.price,
                  'quantity': item.quantity,
                })
            .toList(),
      };

      // 4. Save to Firestore 'orders' collection
      await FirebaseFirestore.instance.collection('orders').add(orderData);

      // 5. Clear ONLY the selected items
      _cartService.clearCart(onlySelected: true);

      // 6. Sync remaining items back to Firestore
      if (user != null) {
        await _cartService.syncToFirestore(user.id);
      }

      // 7. Navigate to Success
      _navigationService.clearStackAndShow(Routes.orderSuccessView);
    } catch (e) {
      print("Error placing order: $e");
    } finally {
      setBusy(false);
    }
  }

  void goBack() {
    _navigationService.back();
  }
}
