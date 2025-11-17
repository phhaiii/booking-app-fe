
class UserResponse {
  final int id;
  final String email;
  final String fullName;
  final String? phone;
  final RoleResponse? role;
  final String? avatar;

  UserResponse({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.role,
    this.avatar,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'],
      role: json['role'] != null ? RoleResponse.fromJson(json['role']) : null,
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role?.toJson(),
      'avatar': avatar,
    };
  }
}

class RoleResponse {
  final int id;
  final String name; // "ADMIN", "VENDOR", "USER"

  RoleResponse({
    required this.id,
    required this.name,
  });

  factory RoleResponse.fromJson(Map<String, dynamic> json) {
    return RoleResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'USER',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }
}