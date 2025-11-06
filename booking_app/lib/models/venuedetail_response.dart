class VenueDetailResponse {
  final String id;
  final String venueId;
  final String title;
  final String subtitle;
  final String description;
  final String location;
  final String imagePath;
  final double price;
  final List<String> images;
  final List<String> amenities;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final VenueContact? contact;
  final List<VenueServiceItem> services;
  final VenueOwner? owner;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VenueDetailResponse({
    required this.id,
    required this.venueId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.location,
    required this.imagePath,
    required this.price,
    required this.images,
    required this.amenities,
    required this.rating,
    required this.reviewCount,
    this.isFavorite = false,
    this.contact,
    required this.services,
    this.owner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VenueDetailResponse.fromJson(Map<String, dynamic> json) {
    return VenueDetailResponse(
      id: json['id'] ?? json['_id'] ?? '',
      venueId: json['venueId'] ?? json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? json['shortDescription'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? json['address'] ?? '',
      imagePath: json['imagePath'] ??
          (json['images'] != null && (json['images'] as List).isNotEmpty
              ? json['images'][0]
              : ''),
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? json['review_count'] ?? 0,
      isFavorite: json['isFavorite'] ?? json['is_favorite'] ?? false,
      contact: json['contact'] != null
          ? VenueContact.fromJson(json['contact'])
          : null,
      services: (json['services'] as List?)
              ?.map((service) => VenueServiceItem.fromJson(service)) // SỬA
              .toList() ??
          [],
      owner: json['owner'] != null ? VenueOwner.fromJson(json['owner']) : null,
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ??
              DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] ?? json['updated_at'] ?? '') ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venueId': venueId,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'location': location,
      'imagePath': imagePath,
      'price': price,
      'images': images,
      'amenities': amenities,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFavorite': isFavorite,
      'contact': contact?.toJson(),
      'services': services.map((s) => s.toJson()).toList(),
      'owner': owner?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  VenueDetailResponse copyWith({
    String? id,
    String? venueId,
    String? title,
    String? subtitle,
    String? description,
    String? location,
    String? imagePath,
    double? price,
    List<String>? images,
    List<String>? amenities, 
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    VenueContact? contact,
    List<VenueServiceItem>? services,
    VenueOwner? owner,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VenueDetailResponse(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      location: location ?? this.location,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      contact: contact ?? this.contact,
      services: services ?? this.services,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class VenueContact {
  final String phone;
  final String email;
  final String address;
  final String website;

  const VenueContact({
    required this.phone,
    required this.email,
    required this.address,
    required this.website,
  });

  factory VenueContact.fromJson(Map<String, dynamic> json) {
    return VenueContact(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'address': address,
      'website': website,
    };
  }
}

// SỬA: Đổi tên từ VenueService thành VenueServiceItem
class VenueServiceItem {
  final String id;
  final String name;
  final String type;
  final double price;
  final String description;
  final List<String> images;

  const VenueServiceItem({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.description,
    required this.images,
  });

  factory VenueServiceItem.fromJson(Map<String, dynamic> json) {
    return VenueServiceItem(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'description': description,
      'images': images,
    };
  }
}

class VenueOwner {
  final String id;
  final String name;
  final String avatar;
  final String phone;
  final double rating;
  final int totalVenues;

  const VenueOwner({
    required this.id,
    required this.name,
    required this.avatar,
    required this.phone,
    required this.rating,
    required this.totalVenues,
  });

  factory VenueOwner.fromJson(Map<String, dynamic> json) {
    return VenueOwner(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      phone: json['phone'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalVenues: json['totalVenues'] ?? json['total_venues'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'rating': rating,
      'totalVenues': totalVenues,
    };
  }
}
