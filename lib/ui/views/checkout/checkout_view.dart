import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'checkout_viewmodel.dart';

class CheckoutView extends StackedView<CheckoutViewModel> {
  const CheckoutView({Key? key}) : super(key: key);

  static const Color legacyBlue = Color(0xFF0D47A1);

  @override
  Widget builder(
      BuildContext context, CheckoutViewModel viewModel, Widget? child) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
        backgroundColor: legacyBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: isMobile ? 20 : 40,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: isMobile
                ? Column(
                    children: [
                      _buildSummarySection(viewModel, isMobile: true),
                      _buildPaymentSection(viewModel, isMobile: true),
                    ],
                  )
                : IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child:
                              _buildSummarySection(viewModel, isMobile: false),
                        ),
                        Expanded(
                          child:
                              _buildPaymentSection(viewModel, isMobile: false),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(CheckoutViewModel viewModel,
      {required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: isMobile
            ? const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: legacyBlue,
            ),
          ),
          const SizedBox(height: 25),
          _priceRow("Subtotal", "₱${viewModel.totalPrice}"),
          _priceRow("Shipping", "FREE"),
          const Divider(height: 40, color: Colors.orangeAccent),
          _priceRow(
            "Total",
            "₱${viewModel.totalPrice}",
            isBold: true,
          ),
          const SizedBox(height: 40),
          const Text(
            "Shipping / Pick-up Details:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: legacyBlue,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  viewModel.userAddress,
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(CheckoutViewModel viewModel,
      {required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Method",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Choose your preferred payment method",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 25),
          _paymentOption(
            title: "Cash at Shop",
            subtitle: "Pay at the counter upon pickup",
            icon: Icons.storefront_outlined,
            isActive: true,
          ),
          const SizedBox(height: 15),
          _paymentOption(
            title: "Cash on Delivery",
            subtitle: "Coming Soon",
            icon: Icons.local_shipping_outlined,
            isActive: false,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: viewModel.isBusy ? null : viewModel.processOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: legacyBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: viewModel.isBusy
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "CONFIRM ORDER",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.blue.withOpacity(0.05)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? legacyBlue.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? legacyBlue : Colors.grey),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive ? Colors.blueGrey : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            const Icon(Icons.radio_button_checked, color: legacyBlue, size: 20)
          else
            const Icon(Icons.lock_outline, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
              color: isBold ? legacyBlue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  CheckoutViewModel viewModelBuilder(BuildContext context) =>
      CheckoutViewModel();
}
