class RegisterRequest {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String address;
  final String dateOfBirth; // Format: YYYY-MM-DD

  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim().toLowerCase(),
      'password': password,
      'fullName': fullName.trim(),
      'phone': phone.trim(),
      'address': address.trim(),
      'dateOfBirth': dateOfBirth, // Backend expects YYYY-MM-DD format
    };
  }

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'RegisterRequest{email: $email, fullName: $fullName, phone: $phone, address: $address, dateOfBirth: $dateOfBirth}';
  }
}
