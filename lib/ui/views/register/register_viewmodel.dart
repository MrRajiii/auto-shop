import 'package:auto_shop/app/app.locator.dart';
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
  // We call notifyListeners() so the 'isFormValid' getter re-evaluates on every keystroke
  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  /// VALIDATION LOGIC
  /// Returns true only if all fields meet the requirements
  bool get isFormValid {
    final bool nameNotEmpty = _name.trim().isNotEmpty;
    final bool addressNotEmpty = _address.trim().isNotEmpty;

    // Basic Email Regex check
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);

    // Password must be at least 6 characters (Firebase default requirement)
    final bool passwordValid = _password.length >= 6;

    return nameNotEmpty && addressNotEmpty && emailValid && passwordValid;
  }

  Future<void> createAccount() async {
    // Safety check: if form isn't valid, don't proceed
    if (!isFormValid) return;

    setBusy(true);
    try {
      await _authService.registerWithEmail(
        fullName: _name.trim(),
        email: _email.trim(),
        address: _address.trim(),
        password: _password,
      );

      _navigationService.replaceWithHomeView();
    } catch (e) {
      print("Error creating account: $e");
      // Optionally use DialogService to show the error to user
    } finally {
      setBusy(false);
    }
  }

  void navigateToLogin() {
    _navigationService.navigateToLoginView();
  }
}
