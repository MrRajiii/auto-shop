class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String address;
  final String? phoneNumber;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.address,
    this.phoneNumber,
  });

  // Convert Map/JSON back to AppUser object
  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'] ?? '',
      // If the database has 'fullName', use it. Otherwise, use 'Guest'
      fullName: data['fullName'] ?? 'Guest',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'address': address,
        'phoneNumber': phoneNumber,
      };
}
