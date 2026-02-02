import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  static const Color legacyBlue = Color(0xFF0D47A1);

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    final screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: isMobile ? screenSize.width * 0.92 : 1000,
            // On desktop we use fixed height, on mobile we let it expand
            height: isMobile ? null : 600,
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

  Widget _buildBranding({required bool isMobile}) {
    return Container(
      // Ensure branding has a significant presence on mobile
      height: isMobile ? 300 : double.infinity,
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
            child: const Icon(Icons.vpn_key_outlined,
                size: 60, color: Colors.white),
          ),
          const SizedBox(height: 30),
          const Text(
            "WELCOME BACK TO\nLEGACY AUTO",
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Log in to access your orders and saved parts.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(LoginViewModel viewModel, {required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 30 : 50,
        vertical: isMobile ? 40 : 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const Text("Enter your details to continue.",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
          _customTextField(
            label: "EMAIL ADDRESS",
            hint: "Enter your email",
            icon: Icons.mail_outline,
            onChanged: viewModel.setEmail,
          ),
          const SizedBox(height: 20),
          _customTextField(
            label: "PASSWORD",
            hint: "Enter password",
            icon: Icons.lock_outline,
            isPassword: true,
            onChanged: viewModel.setPassword,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text("Forgot Password?",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: viewModel.isBusy ? null : viewModel.login,
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
                  : const Text("LOG IN",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                GestureDetector(
                  onTap: viewModel.navigateToRegister,
                  child: const Text(
                    "Sign Up Now",
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
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
