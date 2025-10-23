class UserResponse {
  final int id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? address;
  final String? dateOfBirth;

  UserResponse({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.address,
    this.dateOfBirth,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth,
    };
  }
}