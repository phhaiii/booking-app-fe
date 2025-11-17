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
    try {
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
        reviewCount: json['reviewCount'] ?? 0,
        categoryId: json['categoryId'],
        categoryName: json['categoryName'],
        vendorId: json['vendorId'],
        serviceType: json['serviceType'],
        vendorName: json['vendorName'],
        amenities: (json['amenities'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        isActive: json['isActive'] ?? json['active'] ?? true,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : null,
      );
    } catch (e) {
      print('❌ Error parsing VenueModel: $e');
      print('📦 JSON was: $json');
      rethrow;
    }
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
