import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'register_viewmodel.dart';

class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({Key? key}) : super(key: key);

  static const Color legacyBlue = Color(0xFF0D47A1);

  @override
  Widget builder(
      BuildContext context, RegisterViewModel viewModel, Widget? child) {
    final screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            // Responsive width: 92% of screen on mobile, fixed 1000 on desktop
            width: isMobile ? screenSize.width * 0.92 : 1000,
            // Desktop has a fixed height, mobile expands with content
            height: isMobile ? null : 650,
            margin: const EdgeInsets.symmetric(vertical: 24),
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
            child: isMobile
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildBranding(isMobile: true),
                      _buildForm(viewModel, isMobile: true),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _buildBranding(isMobile: false)),
                      Expanded(child: _buildForm(viewModel, isMobile: false)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // --- BRANDING SECTION ---
  Widget _buildBranding({required bool isMobile}) {
    return Container(
      // Fixed height on mobile to maintain the "Design look", fill height on desktop
      height: isMobile ? 350 : double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: isMobile
            ? const BorderRadius.vertical(top: Radius.circular(16))
            : const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: legacyBlue,
              borderRadius: BorderRadius.circular(24),
            ),
            child:
                const Icon(Icons.local_shipping, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 30),
          const Text(
            "THE FASTEST AUTO\nPARTS HUB",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: legacyBlue,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Join thousands of mechanics and car enthusiasts getting access to high-quality parts daily.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
          ),
          const SizedBox(height: 30),
          // Feature Icons Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FeatureIcon(
                  icon: Icons.verified_user_outlined, label: "GUARANTEED"),
              SizedBox(width: 20),
              _FeatureIcon(
                  icon: Icons.history_toggle_off, label: "24H DELIVERY"),
              SizedBox(width: 20),
              _FeatureIcon(icon: Icons.star_outline, label: "TOP RATED"),
            ],
          )
        ],
      ),
    );
  }

  // --- FORM SECTION ---
  Widget _buildForm(RegisterViewModel viewModel, {required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 50,
        vertical: isMobile ? 40 : 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Register",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const Text("Start your journey with us today.",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          _customTextField(
            label: "FULL NAME",
            hint: "e.g. John Doe",
            icon: Icons.person_outline,
            onChanged: viewModel.setName,
          ),
          const SizedBox(height: 15),
          _customTextField(
            label: "EMAIL ADDRESS",
            hint: "Enter your email",
            icon: Icons.mail_outline,
            onChanged: viewModel.setEmail,
          ),
          const SizedBox(height: 15),
          _customTextField(
            label: "SHIPPING ADDRESS",
            hint: "Street, City, ZIP",
            icon: Icons.location_on_outlined,
            onChanged: viewModel.setAddress,
          ),
          const SizedBox(height: 15),
          _customTextField(
            label: "PASSWORD",
            hint: "Enter password",
            icon: Icons.lock_outline,
            isPassword: true,
            onChanged: viewModel.setPassword,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: viewModel.isBusy ? null : viewModel.createAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: legacyBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: viewModel.isBusy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text("SIGN UP NOW",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                GestureDetector(
                  onTap: () {
                    // Navigate to Login logic here
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey)),
        const SizedBox(height: 5),
        TextField(
          obscureText: isPassword,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: Colors.blueGrey),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
    );
  }

  @override
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel();
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0D47A1), size: 24),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey)),
      ],
    );
  }
}
