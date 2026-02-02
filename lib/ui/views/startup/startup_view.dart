import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add this package to pubspec.yaml
import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, StartupViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Your Legacy Blue
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Your Branding
            const Text(
              'AUTO SHOP & SUPPLY',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Quality Parts for Every Ride',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 50),

            // CUSTOM LOADING ICON
            // Using a SpinKit animation for a "different" look
            const SpinKitFoldingCube(
              color: Colors.white,
              size: 40.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) => StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((track) => viewModel.runStartupLogic());
}
