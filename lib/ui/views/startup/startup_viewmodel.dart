import 'package:auto_shop/app/app.locator.dart';
import 'package:auto_shop/app/app.router.dart';
import 'package:auto_shop/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthenticationService>();

  Future runStartupLogic() async {
    // Give the splash screen a moment to be seen (e.g., 2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    // Even if there is no user, we now route to HomeView instead of LoginView
    if (_authService.currentUser != null) {
      // User is logged in
      _navigationService.replaceWithHomeView();
    } else {
      // No user, but we still want them to see the landing/home page
      _navigationService.replaceWithHomeView();
    }

    // Pro-tip: If the logic is the same for both, you can just use:
    // _navigationService.replaceWithHomeView();
  }
}
