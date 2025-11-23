/// PostModel - Maps to `posts` table in database
/// This is the main venue/service post model
class PostModel {
  final int id;
  final String title;
  final String description;
  final String? content;
  final double price;
  final String currency;
  final String? location;
  final List<String> images;
  final int? capacity;
  final List<String> amenities;
  final int vendorId;
  final String status; // 'PENDING', 'APPROVED', 'REJECTED', 'PUBLISHED'
  final bool isAvailable;
  final double rating;
  final int viewCount;
  final List<String>? workingDays; // JSON array
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool allowComments;
  final int bookingCount;
  final int commentCount;
  final bool enableNotifications;
  final bool isActive;
  final bool isDeleted;
  final int likeCount;
  final DateTime? publishedAt;
  final String? style;
  final int? availableSlots;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    this.content,
    required this.price,
    this.currency = 'VND',
    this.location,
    this.images = const [],
    this.capacity,
    this.amenities = const [],
    required this.vendorId,
    this.status = 'PENDING',
    this.isAvailable = true,
    this.rating = 0.0,
    this.viewCount = 0,
    this.workingDays,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.allowComments = true,
    this.bookingCount = 0,
    this.commentCount = 0,
    this.enableNotifications = true,
    this.isActive = true,
    this.isDeleted = false,
    this.likeCount = 0,
    this.publishedAt,
    this.style,
    this.availableSlots,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'],
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'VND',
      location: json['location'],
      images: json['images'] != null
          ? (json['images'] is List
              ? List<String>.from(json['images'])
              : [json['images'].toString()])
          : [],
      capacity: json['capacity'],
      amenities: json['amenities'] != null
          ? (json['amenities'] is List
              ? List<String>.from(json['amenities'])
              : [])
          : [],
      vendorId: json['vendorId'] ?? json['vendor_id'] ?? 0,
      status: json['status'] ?? 'PENDING',
      isAvailable: json['isAvailable'] ?? json['is_available'] ?? true,
      rating: (json['rating'] ?? 0.0).toDouble(),
      viewCount: json['viewCount'] ?? json['view_count'] ?? 0,
      workingDays: json['workingDays'] != null
          ? (json['workingDays'] is List
              ? List<String>.from(json['workingDays'])
              : null)
          : (json['working_days'] != null
              ? (json['working_days'] is List
                  ? List<String>.from(json['working_days'])
                  : null)
              : null),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now()),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : (json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'])
              : null),
      allowComments: json['allowComments'] ?? json['allow_comments'] ?? true,
      bookingCount: json['bookingCount'] ?? json['booking_count'] ?? 0,
      commentCount: json['commentCount'] ?? json['comment_count'] ?? 0,
      enableNotifications:
          json['enableNotifications'] ?? json['enable_notifications'] ?? true,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      isDeleted: json['isDeleted'] ?? json['is_deleted'] ?? false,
      likeCount: json['likeCount'] ?? json['like_count'] ?? 0,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : (json['published_at'] != null
              ? DateTime.tryParse(json['published_at'])
              : null),
      style: json['style'],
      availableSlots: json['availableSlots'] ?? json['available_slots'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      if (content != null) 'content': content,
      'price': price,
      'currency': currency,
      if (location != null) 'location': location,
      'images': images,
      if (capacity != null) 'capacity': capacity,
      'amenities': amenities,
      'vendorId': vendorId,
      'status': status,
      'isAvailable': isAvailable,
      'rating': rating,
      'viewCount': viewCount,
      if (workingDays != null) 'workingDays': workingDays,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
      'allowComments': allowComments,
      'bookingCount': bookingCount,
      'commentCount': commentCount,
      'enableNotifications': enableNotifications,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'likeCount': likeCount,
      if (publishedAt != null) 'publishedAt': publishedAt!.toIso8601String(),
      if (style != null) 'style': style,
      if (availableSlots != null) 'availableSlots': availableSlots,
    };
  }

  // Convert to VenueModel for backward compatibility
  VenueModel toVenueModel({
    String? vendorName,
    String? city,
  }) {
    return VenueModel(
      id: id,
      name: title,
      description: description,
      address: location ?? '',
      city: city ?? '',
      price: price,
      capacity: capacity ?? 0,
      style: style,
      thumbnailImage: images.isNotEmpty ? images.first : null,
      imageUrls: images,
      rating: rating,
      reviewCount: commentCount,
      vendorId: vendorId,
      vendorName: vendorName,
      amenities: amenities,
      isActive: isActive && !isDeleted,
      createdAt: createdAt,
    );
  }

  // Create from VenueModel
  factory PostModel.fromVenueModel(VenueModel venue) {
    return PostModel(
      id: venue.id,
      title: venue.name,
      description: venue.description,
      price: venue.price,
      location: venue.address,
      images: venue.imageUrls,
      capacity: venue.capacity,
      amenities: venue.amenities,
      vendorId: venue.vendorId ?? 0,
      rating: venue.rating,
      isActive: venue.isActive,
      createdAt: venue.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      style: venue.style,
      commentCount: venue.reviewCount,
    );
  }

  // Helper getters
  bool get isPublished => status == 'PUBLISHED';
  bool get isPending => status == 'PENDING';
  bool get isApproved => status == 'APPROVED';
  bool get isRejected => status == 'REJECTED';

  String get statusDisplay {
    switch (status.toUpperCase()) {
      case 'PUBLISHED':
        return 'Đã xuất bản';
      case 'PENDING':
        return 'Chờ duyệt';
      case 'APPROVED':
        return 'Đã duyệt';
      case 'REJECTED':
        return 'Bị từ chối';
      default:
        return status;
    }
  }

  String get thumbnailImage => images.isNotEmpty ? images.first : '';

  bool get hasWorkingDays => workingDays != null && workingDays!.isNotEmpty;

  String get formattedPrice {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}tr';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return '${price.toStringAsFixed(0)}đ';
  }

  // Copy with method
  PostModel copyWith({
    int? id,
    String? title,
    String? description,
    String? content,
    double? price,
    String? currency,
    String? location,
    List<String>? images,
    int? capacity,
    List<String>? amenities,
    int? vendorId,
    String? status,
    bool? isAvailable,
    double? rating,
    int? viewCount,
    List<String>? workingDays,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? allowComments,
    int? bookingCount,
    int? commentCount,
    bool? enableNotifications,
    bool? isActive,
    bool? isDeleted,
    int? likeCount,
    DateTime? publishedAt,
    String? style,
    int? availableSlots,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      location: location ?? this.location,
      images: images ?? this.images,
      capacity: capacity ?? this.capacity,
      amenities: amenities ?? this.amenities,
      vendorId: vendorId ?? this.vendorId,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      viewCount: viewCount ?? this.viewCount,
      workingDays: workingDays ?? this.workingDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      allowComments: allowComments ?? this.allowComments,
      bookingCount: bookingCount ?? this.bookingCount,
      commentCount: commentCount ?? this.commentCount,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      likeCount: likeCount ?? this.likeCount,
      publishedAt: publishedAt ?? this.publishedAt,
      style: style ?? this.style,
      availableSlots: availableSlots ?? this.availableSlots,
    );
  }
}

// Import VenueModel if needed for conversion
class VenueModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String city;
  final double price;
  final int capacity;
  final String? style;
  final String? thumbnailImage;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final int? categoryId;
  final String? categoryName;
  final int? vendorId;
  final String? vendorName;
  final List<String> amenities;
  final bool isActive;
  final DateTime? createdAt;
  final String? serviceType;

  VenueModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    this.city = '',
    required this.price,
    required this.capacity,
    this.style,
    this.thumbnailImage,
    required this.imageUrls,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.categoryId,
    this.categoryName,
    this.vendorId,
    this.vendorName,
    this.amenities = const [],
    this.isActive = true,
    this.createdAt,
    this.serviceType,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'] ?? 0,
      name: json['title'] ?? json['name'] ?? 'Unknown',
      description: json['description'] ?? '',
      address: json['location'] ?? json['address'] ?? '',
      city: json['city'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      capacity: json['capacity'] ?? 0,
      style: json['style'],
      thumbnailImage: json['thumbnailImage'],
      imageUrls: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? json['commentCount'] ?? 0,
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      vendorId: json['vendorId'] ?? json['vendor_id'],
      serviceType: json['serviceType'],
      vendorName: json['vendorName'],
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isActive: json['isActive'] ?? json['active'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'description': description,
      'location': address,
      'city': city,
      'price': price,
      'capacity': capacity,
      'style': style,
      'thumbnailImage': thumbnailImage,
      'images': imageUrls,
      'rating': rating,
      'reviewCount': reviewCount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'amenities': amenities,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
