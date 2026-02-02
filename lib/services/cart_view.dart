import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:auto_shop/models/cart_item.dart'; // Ensure this import is correct
import 'cart_viewmodel.dart';

class CartView extends StackedView<CartViewModel> {
  const CartView({Key? key}) : super(key: key);

  static const Color legacyBlue = Color(0xFF0D47A1);

  @override
  Widget builder(BuildContext context, CartViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Your Basket'),
        backgroundColor: legacyBlue,
        elevation: 0,
      ),
      body: viewModel.items.isEmpty
          ? _buildEmptyCart(viewModel)
          : Center(
              child: Container(
                width: 1200, // Slightly wider for the cart layout
                height: 700,
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // LEFT SIDE: Items List
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Shopping Cart",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            const Divider(),
                            Expanded(
                              child: ListView.separated(
                                itemCount: viewModel.items.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, index) {
                                  final item = viewModel.items[index];
                                  return _CartItemTile(
                                    item: item,
                                    // FIX: Passing the productId String to match ViewModel
                                    onRemove: () =>
                                        viewModel.removeItem(item.product.id),
                                  );
                                },
                              ),
                            ),
                            TextButton.icon(
                              onPressed: viewModel.navigateToHome,
                              icon: const Icon(Icons.arrow_back, size: 16),
                              label: const Text("Continue Shopping"),
                              style: TextButton.styleFrom(
                                  foregroundColor: legacyBlue),
                            )
                          ],
                        ),
                      ),
                    ),

                    // RIGHT SIDE: Summary & Checkout
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF3E0), // Branding cream
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Order Summary",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: legacyBlue)),
                            const SizedBox(height: 30),
                            _summaryRow("Items", "${viewModel.items.length}"),
                            _summaryRow("Shipping", "FREE"),
                            const Spacer(),
                            const Divider(color: Colors.blueGrey),
                            _summaryRow(
                                "Total Cost", "₱${viewModel.totalPrice}",
                                isTotal: true),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: viewModel.checkout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: legacyBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("CHECKOUT NOW",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: isTotal ? 22 : 14,
                  fontWeight: FontWeight.bold,
                  color: isTotal ? legacyBlue : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(CartViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined,
              size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text("Your basket is empty",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: viewModel.navigateToHome,
            style: ElevatedButton.styleFrom(backgroundColor: legacyBlue),
            child: const Text("GO SHOPPING",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  CartViewModel viewModelBuilder(BuildContext context) => CartViewModel();
}

class _CartItemTile extends StatelessWidget {
  final CartItem item; // Corrected from dynamic to CartItem
  final VoidCallback onRemove;
  const _CartItemTile({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(item.product.imageUrls[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item.product.category,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text("x${item.quantity}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 20),
          Text("₱${item.product.price}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onRemove,
          )
        ],
      ),
    );
  }
}
