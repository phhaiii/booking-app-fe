class UserResponse {
  final int id;
  final String email;
  final String fullName;
  final String? phone;
  final String? address;
  final String? dateOfBirth;
  final String? avatarUrl;
  final String roleName;
  final bool isActive;
  final String? createdAt;

  UserResponse({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.avatarUrl,
    required this.roleName,
    required this.isActive,
    this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'],
      avatarUrl: json['avatarUrl'],
      roleName: json['roleName'] ?? 'CUSTOMER',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'],
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
      'avatarUrl': avatarUrl,
      'roleName': roleName,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}
