import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({Key? key}) : super(key: key);

  static const Color legacyBlue = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    // Accessing navigation service directly for the button action
    final navigationService = locator<NavigationService>();

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(isMobile ? 24 : 32),
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon - Scaled for mobile
                  Icon(
                    Icons.check_circle_outline,
                    size: isMobile ? 80 : 120,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 30),

                  // Title - Responsive Font Size
                  Text(
                    "ORDER RESERVED!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 26 : 36,
                      fontWeight: FontWeight.bold,
                      color: legacyBlue,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Instructional Text
                  Text(
                    "Your items have been set aside for you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Please visit our shop branch to complete your payment and pick up your parts. We'll hold your reservation for the next 48 hours.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: isMobile ? 14 : 15,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Payment Method Info Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Payment Method",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.storefront,
                                size: 18, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              "CASH AT SHOP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () =>
                          navigationService.clearStackAndShow(Routes.homeView),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: legacyBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "CONTINUE SHOPPING",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),

                  if (isMobile) const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
