import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({Key? key}) : super(key: key);

  static const Color legacyBlue = Color(0xFF0D47A1);

  @override
  Widget builder(
      BuildContext context, ProfileViewModel viewModel, Widget? child) {
    final user = viewModel.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800;

    // Safety check: If user logs out, show a loader while the navigation triggers
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: legacyBlue)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: legacyBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Container(
              width: isMobile ? screenWidth * 0.92 : 1000,
              margin: EdgeInsets.symmetric(
                vertical: isMobile ? 20 : 40,
                horizontal: isMobile ? 10 : 24,
              ),
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
                        _buildBrandingSection(user.fullName, true),
                        _buildDetailsSection(viewModel, user, true),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: _buildBrandingSection(user.fullName, false),
                        ),
                        Expanded(
                          flex: 6,
                          child: _buildDetailsSection(viewModel, user, false),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandingSection(String fullName, bool isMobile) {
    return Container(
      constraints: BoxConstraints(minHeight: isMobile ? 0 : 600),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: legacyBlue,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 30),
          Text(
            "HELLO,\n${fullName.split(' ')[0].toUpperCase()}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: legacyBlue,
              fontSize: isMobile ? 26 : 32,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Manage your account details and shipping information here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(
      ProfileViewModel viewModel, dynamic user, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 50,
        vertical: 40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Account Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          _infoDisplay(
            label: "FULL NAME",
            value: user.fullName,
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 20),
          _infoDisplay(
            label: "EMAIL ADDRESS",
            value: user.email,
            icon: Icons.mail_outline,
          ),
          const SizedBox(height: 20),
          _buildEditableAddress(viewModel, user.address),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: viewModel.logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("LOGOUT",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoDisplay(
      {required String label, required String value, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey)),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(icon, size: 20, color: legacyBlue),
            const SizedBox(width: 10),
            Expanded(
                child: Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500))),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildEditableAddress(
      ProfileViewModel viewModel, String currentAddress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("SHIPPING ADDRESS",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            IconButton(
              icon: Icon(viewModel.isEditing ? Icons.close : Icons.edit,
                  size: 18, color: legacyBlue),
              onPressed: viewModel.toggleEdit,
            ),
          ],
        ),
        if (viewModel.isEditing)
          Column(
            children: [
              TextField(
                onChanged: viewModel.setNewAddress,
                decoration: const InputDecoration(
                    hintText: "Enter new address", isDense: true),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isBusy ? null : viewModel.saveAddress,
                  style: ElevatedButton.styleFrom(backgroundColor: legacyBlue),
                  child: viewModel.isBusy
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text("SAVE CHANGES",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 20, color: legacyBlue),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                      currentAddress.isEmpty
                          ? "No address set"
                          : currentAddress,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500))),
            ],
          ),
        const Divider(),
      ],
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}
