class CheckListItem {
  final String? id;
  String title;
  String? description;
  bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  DateTime? completedAt;

  CheckListItem({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  // ✅ Convert từ JSON (từ Spring Boot backend)
  factory CheckListItem.fromJson(Map<String, dynamic> json) {
    return CheckListItem(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  // ✅ Convert sang JSON (gửi lên Spring Boot)
  // Chỉ gửi title và description khi create/update
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      // Không gửi id, isCompleted, timestamps (backend tự xử lý)
    };
  }

  // Helper method để update từ response
  CheckListItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return CheckListItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  void toggleCompleted() {
    isCompleted = !isCompleted;
    completedAt = isCompleted ? DateTime.now() : null;
  }
}
