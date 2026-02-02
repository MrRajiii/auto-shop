import 'package:auto_shop/app/app.locator.dart'; // Ensure this path is correct
import 'package:auto_shop/app/app.router.dart';
import 'package:auto_shop/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  String _name = '';
  String _email = '';
  String _address = '';
  String _password = '';

  // Setters called by the View's onChanged
  void setName(String value) => _name = value;
  void setEmail(String value) => _email = value;
  void setAddress(String value) => _address = value;
  void setPassword(String value) => _password = value;

  Future<void> createAccount() async {
    setBusy(true);
    try {
      await _authService.registerWithEmail(
        fullName: _name,
        email: _email,
        address: _address,
        password: _password,
      );
      // Navigate to Home after successful registration
      _navigationService.replaceWithHomeView();
    } catch (e) {
      // You could add an error message property here
    } finally {
      setBusy(false);
    }
  }
}
