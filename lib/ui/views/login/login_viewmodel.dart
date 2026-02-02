import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/authentication_service.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>(); // Added for error alerts

  String _email = '';
  String _password = '';

  void setEmail(String value) => _email = value;
  void setPassword(String value) => _password = value;

  Future<void> login() async {
    // 1. Basic Validation
    if (_email.isEmpty || _password.isEmpty) {
      await _dialogService.showDialog(
        title: 'Login Error',
        description: 'Please enter both email and password.',
      );
      return;
    }

    setBusy(true);

    // 2. Call the actual Authentication Service
    // Ensure your AuthService has a login method that returns a bool or User object
    final success = await _authService.login(
      email: _email,
      password: _password,
    );

    setBusy(false);

    if (success) {
      // 3. Move to Home on success
      _navigationService.replaceWithHomeView();
    } else {
      // 4. Handle Failure
      await _dialogService.showDialog(
        title: 'Login Failed',
        description: 'Invalid email or password. Please try again.',
      );
    }
  }

  void navigateToRegister() {
    _navigationService.navigateToRegisterView();
  }
}
