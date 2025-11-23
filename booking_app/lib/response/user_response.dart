class UserResponse {
  final int id;
  final String email;
  final String fullName;
  final String? phone;
  final String? address;
  final DateTime? dateOfBirth;
  final RoleResponse? role;
  final String? avatar;
  final String? avatarUrl;
  final DateTime? emailVerifiedAt;
  final String? verificationToken;
  final bool isActive;
  final bool isLocked;
  final int failedLoginAttempts;
  final DateTime? lockedUntil;
  final DateTime? deletedAt;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserResponse({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.role,
    this.avatar,
    this.avatarUrl,
    this.emailVerifiedAt,
    this.verificationToken,
    this.isActive = true,
    this.isLocked = false,
    this.failedLoginAttempts = 0,
    this.lockedUntil,
    this.deletedAt,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      phone: json['phone'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : (json['date_of_birth'] != null
              ? DateTime.tryParse(json['date_of_birth'])
              : null),
      role: json['role'] != null ? RoleResponse.fromJson(json['role']) : null,
      avatar: json['avatar'],
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'] ?? json['avatar'],
      emailVerifiedAt: json['emailVerifiedAt'] != null
          ? DateTime.tryParse(json['emailVerifiedAt'])
          : (json['email_verified_at'] != null
              ? DateTime.tryParse(json['email_verified_at'])
              : null),
      verificationToken:
          json['verificationToken'] ?? json['verification_token'],
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      isLocked: json['isLocked'] ?? json['is_locked'] ?? false,
      failedLoginAttempts:
          json['failedLoginAttempts'] ?? json['failed_login_attempts'] ?? 0,
      lockedUntil: json['lockedUntil'] != null
          ? DateTime.tryParse(json['lockedUntil'])
          : (json['locked_until'] != null
              ? DateTime.tryParse(json['locked_until'])
              : null),
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : (json['deleted_at'] != null
              ? DateTime.tryParse(json['deleted_at'])
              : null),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : (json['last_login_at'] != null
              ? DateTime.tryParse(json['last_login_at'])
              : null),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : (json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (role != null) 'role': role!.toJson(),
      if (avatar != null) 'avatar': avatar,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (emailVerifiedAt != null)
        'emailVerifiedAt': emailVerifiedAt!.toIso8601String(),
      if (verificationToken != null) 'verificationToken': verificationToken,
      'isActive': isActive,
      'isLocked': isLocked,
      'failedLoginAttempts': failedLoginAttempts,
      if (lockedUntil != null) 'lockedUntil': lockedUntil!.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

class RoleResponse {
  final int id;
  final String roleName; // "ADMIN", "VENDOR", "USER"
  final String? description;
  final List<String>? permissions;

  RoleResponse({
    required this.id,
    required this.roleName,
    this.description,
    this.permissions,
  });

  // Getter for backward compatibility
  String get name => roleName;

  factory RoleResponse.fromJson(Map<String, dynamic> json) {
    return RoleResponse(
      id: json['id'] ?? 0,
      roleName: json['roleName'] ?? json['role_name'] ?? json['name'] ?? 'USER',
      description: json['description'],
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roleName': roleName,
      if (description != null) 'description': description,
      if (permissions != null) 'permissions': permissions,
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
