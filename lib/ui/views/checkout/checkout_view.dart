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
                      _buildFormAndPaymentSection(viewModel, isMobile: true),
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
                          child: _buildFormAndPaymentSection(viewModel,
                              isMobile: false),
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
          ...viewModel.selectedItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Text("${item.quantity}x",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: legacyBlue)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(item.product.name,
                            style: const TextStyle(fontSize: 13))),
                    Text("₱${item.product.price}"),
                  ],
                ),
              )),
          const Divider(height: 40, color: Colors.orangeAccent),
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
            "Quick Note:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: legacyBlue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please ensure your contact details are correct so we can reach you regarding your order status.",
            style: TextStyle(color: Colors.blueGrey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildFormAndPaymentSection(CheckoutViewModel viewModel,
      {required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Shipping Details",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: "Full Name",
            hint: "Enter your full name",
            icon: Icons.person_outline,
            // VALIDATION: Show error if submission failed and field is empty
            errorText: viewModel.showValidationErrors && !viewModel.isNameValid
                ? "Name is required"
                : null,
            onChanged: (val) => viewModel.updateName(val),
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: "Phone Number",
            hint: "09XX XXX XXXX",
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            // VALIDATION: Basic length check for PH numbers
            errorText: viewModel.showValidationErrors && !viewModel.isPhoneValid
                ? "Valid 10+ digit number required"
                : null,
            onChanged: (val) => viewModel.updatePhone(val),
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: "Complete Address",
            hint: "Street, Brgy, City, Province",
            icon: Icons.location_on_outlined,
            maxLines: 2,
            // VALIDATION: Check if empty
            errorText:
                viewModel.showValidationErrors && !viewModel.isAddressValid
                    ? "Complete address is required"
                    : null,
            onChanged: (val) => viewModel.updateAddress(val),
          ),
          const SizedBox(height: 30),
          const Text(
            "Payment Method",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _paymentOption(
            title: "Cash at Shop",
            subtitle: "Pay at the counter upon pickup",
            icon: Icons.storefront_outlined,
            isActive: true,
          ),
          const SizedBox(height: 15),
          _paymentOption(
            title: "Cash on Delivery",
            subtitle: "Currently unavailable",
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    String? errorText, // ADDED: New parameter for validation message
    TextInputType? keyboardType,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText, // ADDED: Connect to TextField error state
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            prefixIcon: Icon(icon, size: 20, color: legacyBlue),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            // Style for the error message
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
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
