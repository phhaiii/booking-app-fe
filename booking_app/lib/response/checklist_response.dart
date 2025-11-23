class CheckListItem {
  final String id; // VARCHAR in database
  String title;
  String? description;
  bool isCompleted;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  DateTime? completedAt;

  CheckListItem({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  // ✅ Convert từ JSON (từ Spring Boot backend)
  factory CheckListItem.fromJson(Map<String, dynamic> json) {
    return CheckListItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      isCompleted: json['isCompleted'] ?? json['is_completed'] ?? false,
      userId: json['userId'] ?? json['user_id'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : (json['completed_at'] != null
              ? DateTime.parse(json['completed_at'])
              : null),
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
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return CheckListItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
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
