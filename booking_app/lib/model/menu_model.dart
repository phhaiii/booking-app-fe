class MenuModel {
  final int? id;
  final String name;
  final String description;
  final int vendorId;
  final int? postId;
  final String? category;
  final double price;
  final double pricePerPerson;
  final int guestsPerTable;
  final String unit;
  final String currency;
  final bool isAvailable;
  final bool isActive;
  final int minOrderQuantity;
  final int? maxOrderQuantity;
  final List<String> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  MenuModel({
    this.id,
    required this.name,
    required this.description,
    required this.vendorId,
    this.postId,
    this.category,
    required this.price,
    required this.pricePerPerson,
    required this.guestsPerTable,
    this.unit = 'portion',
    this.currency = 'VND',
    this.isAvailable = true,
    this.isActive = true,
    this.minOrderQuantity = 1,
    this.maxOrderQuantity,
    required this.items,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // ✅ GETTERS để tương thích với UI cũ
  List<String> get dishes => items;

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      vendorId: json['vendorId'] ?? json['vendor_id'] ?? 0,
      postId: json['postId'] ?? json['post_id'],
      category: json['category'],
      price: (json['price'] ?? 0).toDouble(),
      pricePerPerson:
          (json['pricePerPerson'] ?? json['price_per_person'] ?? 0).toDouble(),
      guestsPerTable: json['guestsPerTable'] ?? json['guests_per_table'] ?? 10,
      unit: json['unit'] ?? 'portion',
      currency: json['currency'] ?? 'VND',
      isAvailable: json['isAvailable'] ?? json['is_available'] ?? true,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      minOrderQuantity:
          json['minOrderQuantity'] ?? json['min_order_quantity'] ?? 1,
      maxOrderQuantity: json['maxOrderQuantity'] ?? json['max_order_quantity'],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : (json['deleted_at'] != null
              ? DateTime.tryParse(json['deleted_at'])
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'vendorId': vendorId,
      if (postId != null) 'postId': postId,
      if (category != null) 'category': category,
      'price': price,
      'pricePerPerson': pricePerPerson,
      'guestsPerTable': guestsPerTable,
      'unit': unit,
      'currency': currency,
      'isAvailable': isAvailable,
      'isActive': isActive,
      'minOrderQuantity': minOrderQuantity,
      if (maxOrderQuantity != null) 'maxOrderQuantity': maxOrderQuantity,
      'items': items,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
    };
  }

  // ✅ THÊM: Tạo request body cho API create/update (STATIC METHOD)
  static Map<String, dynamic> toCreateRequest({
    required String name,
    required String description,
    required int vendorId,
    int? postId,
    String? category,
    required double price,
    required double pricePerPerson,
    required int guestsPerTable,
    String unit = 'portion',
    String currency = 'VND',
    bool isAvailable = true,
    int minOrderQuantity = 1,
    int? maxOrderQuantity,
    required List<String> items,
  }) {
    return {
      'name': name,
      'description': description,
      'vendorId': vendorId,
      if (postId != null) 'postId': postId,
      if (category != null) 'category': category,
      'price': price,
      'pricePerPerson': pricePerPerson,
      'guestsPerTable': guestsPerTable,
      'unit': unit,
      'currency': currency,
      'isAvailable': isAvailable,
      'minOrderQuantity': minOrderQuantity,
      if (maxOrderQuantity != null) 'maxOrderQuantity': maxOrderQuantity,
      'items': items,
    };
  }

  // ✅ Helper methods
  double calculateTotalForTables(int numberOfTables) {
    return price * numberOfTables;
  }

  int calculateTablesNeeded(int totalGuests) {
    return (totalGuests / guestsPerTable).ceil();
  }

  double calculateTotalForGuests(int totalGuests) {
    int tables = calculateTablesNeeded(totalGuests);
    return calculateTotalForTables(tables);
  }

  // ✅ Copy with method
  MenuModel copyWith({
    int? id,
    String? name,
    String? description,
    int? vendorId,
    int? postId,
    String? category,
    double? price,
    double? pricePerPerson,
    int? guestsPerTable,
    String? unit,
    String? currency,
    bool? isAvailable,
    bool? isActive,
    int? minOrderQuantity,
    int? maxOrderQuantity,
    List<String>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return MenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      vendorId: vendorId ?? this.vendorId,
      postId: postId ?? this.postId,
      category: category ?? this.category,
      price: price ?? this.price,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      guestsPerTable: guestsPerTable ?? this.guestsPerTable,
      unit: unit ?? this.unit,
      currency: currency ?? this.currency,
      isAvailable: isAvailable ?? this.isAvailable,
      isActive: isActive ?? this.isActive,
      minOrderQuantity: minOrderQuantity ?? this.minOrderQuantity,
      maxOrderQuantity: maxOrderQuantity ?? this.maxOrderQuantity,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
