class RegisterRequest {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String? address;
  final String? dateOfBirth;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    this.address,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth,
    };
  }
}
