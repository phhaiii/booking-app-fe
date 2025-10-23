class VenueModel {
  final String venueId;
  final String title;
  final String subtitle;
  final String imagePath;
  final String location;
  final double price;
  final List<String> amenities;
  final double rating;
  final int reviewCount;
  final bool isFavorite;

  const VenueModel({
    required this.venueId,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.location,
    required this.price,
    required this.amenities,
    required this.rating,
    required this.reviewCount,
    this.isFavorite = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'title': title,
      'subtitle': subtitle,
      'imagePath': imagePath,
      'location': location,
      'price': price,
      'amenities': amenities,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFavorite': isFavorite,
    };
  }

  // Create from JSON
  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      venueId: json['venueId'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imagePath: json['imagePath'] ?? '',
      location: json['location'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      amenities: List<String>.from(json['amenities'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Copy with method for updates
  VenueModel copyWith({
    String? venueId,
    String? title,
    String? subtitle,
    String? imagePath,
    String? location,
    double? price,
    List<String>? amenities,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
  }) {
    return VenueModel(
      venueId: venueId ?? this.venueId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imagePath: imagePath ?? this.imagePath,
      location: location ?? this.location,
      price: price ?? this.price,
      amenities: amenities ?? this.amenities,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Empty const constructor for legacy support
  static const VenueModel empty = VenueModel(
    venueId: '',
    title: '',
    subtitle: '',
    imagePath: '',
    location: '',
    price: 0,
    amenities: <String>[],
    rating: 0,
    reviewCount: 0,
    isFavorite: false,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VenueModel &&
        other.venueId == venueId &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.imagePath == imagePath &&
        other.location == location &&
        other.price == price &&
        other.rating == rating &&
        other.reviewCount == reviewCount &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return Object.hash(
      venueId,
      title,
      subtitle,
      imagePath,
      location,
      price,
      rating,
      reviewCount,
      isFavorite,
    );
  }

  @override
  String toString() {
    return 'VenueModel(venueId: $venueId, title: $title, price: $price, rating: $rating)';
  }
}
