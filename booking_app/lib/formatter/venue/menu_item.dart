class MenuItem {
  final String id;
  final String name;
  final double price;
  final int guestsPerTable;
  final List<String> dishes;
  final String? description;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.guestsPerTable,
    required this.dishes,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'guestsPerTable': guestsPerTable,
      'dishes': dishes,
      'description': description,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      guestsPerTable: json['guestsPerTable'] ?? 0,
      dishes: json['dishes'] != null ? List<String>.from(json['dishes']) : [],
      description: json['description'],
    );
  }

  MenuItem copyWith({
    String? id,
    String? name,
    double? price,
    int? guestsPerTable,
    List<String>? dishes,
    String? description,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      guestsPerTable: guestsPerTable ?? this.guestsPerTable,
      dishes: dishes ?? this.dishes,
      description: description ?? this.description,
    );
  }
}