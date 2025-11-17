import 'package:booking_app/model/menu_model.dart';

class VenueDetailResponse {
  final int id;
  final String title;
  final String description;
  final String content;
  final String location;
  final double price;
  final int capacity;
  final String? style;
  final List<String> images;
  final List<String> amenities;
  final List<MenuModel> menus;
  final bool allowComments;
  final bool enableNotifications;
  final String status;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final int bookingCount;
  final VendorInfo vendor;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
  final bool isFavorite;
  final double rating;
  final int reviewCount;

  const VenueDetailResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.location,
    required this.price,
    required this.capacity,
    this.style,
    required this.images,
    required this.amenities,
    this.menus = const [],
    required this.allowComments,
    required this.enableNotifications,
    required this.status,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.bookingCount,
    required this.vendor,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
    this.isFavorite = false,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  // ✅ THÊM: Contact info getter (lấy từ vendor)
  ContactInfo? get contact {
    if (vendor.phoneNumber != null && vendor.phoneNumber!.isNotEmpty) {
      return ContactInfo(
        phone: vendor.phoneNumber!,
        email: vendor.email,
      );
    }
    return null;
  }

  factory VenueDetailResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing VenueDetailResponse...');
      print('JSON keys: ${json.keys.toList()}');

      return VenueDetailResponse(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        content: json['content'] ?? '',
        location: json['location'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        capacity: json['capacity'] ?? 0,
        style: json['style'],
        images: (json['images'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        amenities: (json['amenities'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        menus: (json['menus'] as List<dynamic>?)
                ?.map((e) => MenuModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        allowComments: json['allowComments'] ?? true,
        enableNotifications: json['enableNotifications'] ?? true,
        status: json['status'] ?? 'PUBLISHED',
        viewCount: json['viewCount'] ?? 0,
        likeCount: json['likeCount'] ?? 0,
        commentCount: json['commentCount'] ?? 0,
        bookingCount: json['bookingCount'] ?? 0,
        vendor: VendorInfo.fromJson(json['vendor'] ?? {}),
        isActive: json['isActive'] ?? true,
        isDeleted: json['isDeleted'] ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
        publishedAt: json['publishedAt'] != null
            ? DateTime.tryParse(json['publishedAt'])
            : null,
        isFavorite: json['isFavorite'] ?? false,
        rating: (json['rating'] ?? 0).toDouble(),
        reviewCount: json['reviewCount'] ?? 0,
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing VenueDetailResponse: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'location': location,
      'price': price,
      'capacity': capacity,
      'style': style,
      'images': images,
      'amenities': amenities,
      'menus': menus.map((m) => m.toJson()).toList(),
      'allowComments': allowComments,
      'enableNotifications': enableNotifications,
      'status': status,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'bookingCount': bookingCount,
      'vendor': vendor.toJson(),
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt?.toIso8601String(),
      'isFavorite': isFavorite,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  bool get hasMenus => menus.isNotEmpty;
  int get menuCount => menus.length;
  List<MenuModel> get activeMenus =>
      menus.where((menu) => menu.isActive).toList();
  String get menuPriceRange {
    if (menus.isEmpty) return 'Chưa có thực đơn';

    final prices = menus.map((m) => m.price).toList()..sort();
    final minPrice = prices.first;
    final maxPrice = prices.last;

    if (minPrice == maxPrice) {
      return _formatPrice(minPrice);
    }
    return '${_formatPrice(minPrice)} - ${_formatPrice(maxPrice)}';
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}tr';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return '${price.toStringAsFixed(0)}đ';
  }

  VenueDetailResponse copyWith({
    int? id,
    String? title,
    String? description,
    String? content,
    String? location,
    double? price,
    int? capacity,
    String? style,
    List<String>? images,
    List<String>? amenities,
    List<MenuModel>? menus,
    bool? allowComments,
    bool? enableNotifications,
    String? status,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    int? bookingCount,
    VendorInfo? vendor,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    bool? isFavorite,
    double? rating,
    int? reviewCount,
  }) {
    return VenueDetailResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      location: location ?? this.location,
      price: price ?? this.price,
      capacity: capacity ?? this.capacity,
      style: style ?? this.style,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      menus: menus ?? this.menus,
      allowComments: allowComments ?? this.allowComments,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      status: status ?? this.status,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      bookingCount: bookingCount ?? this.bookingCount,
      vendor: vendor ?? this.vendor,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// VENDOR INFO
// ═══════════════════════════════════════════════════════════════

class VendorInfo {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? avatar;
  final String role;

  const VendorInfo({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.avatar,
    required this.role,
  });

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    return VendorInfo(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? 'Unknown',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? json['phoneNumber'], // Backend uses 'phone'
      avatar: json['avatar'],
      role: json['role'] ?? 'VENDOR',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'role': role,
    };
  }

  // ✅ Helper: Get display name
  String get displayName => fullName.isNotEmpty ? fullName : email;

  // ✅ Helper: Check if has avatar
  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;

  // ✅ Helper: Get initials for avatar placeholder
  String get initials {
    if (fullName.isEmpty) return '?';
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
    }
    return fullName[0].toUpperCase();
  }
}

// ✅ THÊM: ContactInfo class
class ContactInfo {
  final String phone;
  final String email;

  const ContactInfo({
    required this.phone,
    required this.email,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
    };
  }
}
