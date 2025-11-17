class MenuModel {
  final int? id;
  final String name;
  final String description;

  // ✅ CHỈ 2 FIELD CHÍNH
  final double price; // Giá tổng menu
  final int guestsPerTable; // Số khách/bàn

  // ✅ Calculated
  final double pricePerPerson; // Giá/người

  final List<String> items;
  final bool isActive;
  final DateTime? createdAt;

  MenuModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.guestsPerTable,
    required this.pricePerPerson,
    required this.items,
    this.isActive = true,
    this.createdAt,
  });

  // ✅ GETTERS để tương thích với UI cũ
  List<String> get dishes => items;

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      guestsPerTable: json['guestsPerTable'] ?? 10,
      pricePerPerson: (json['pricePerPerson'] ?? 0).toDouble(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'guestsPerTable': guestsPerTable,
      'pricePerPerson': pricePerPerson,
      'items': items,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  // ✅ THÊM: Tạo request body cho API create/update (STATIC METHOD)
  static Map<String, dynamic> toCreateRequest({
    required String name,
    required String description,
    required double price,
    required int guestsPerTable,
    required List<String> items,
  }) {
    return {
      'name': name,
      'description': description,
      'price': price,
      'guestsPerTable': guestsPerTable,
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
    double? price,
    int? guestsPerTable,
    double? pricePerPerson,
    List<String>? items,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return MenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      guestsPerTable: guestsPerTable ?? this.guestsPerTable,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      items: items ?? this.items,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
