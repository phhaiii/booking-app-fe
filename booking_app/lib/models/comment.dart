import 'package:intl/intl.dart';

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String content;
  final List<String> images;
  final int likes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.rating,
    required this.content,
    this.images = const [],
    this.likes = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ THÊM: Getter để format date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Vừa xong';
        }
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks tuần trước';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(createdAt);
    }
  }

  // ✅ THÊM: Getter để format date đầy đủ
  String get formattedFullDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(createdAt);
  }

  // ✅ THÊM: Getter để format date ngắn gọn
  String get formattedShortDate {
    return DateFormat('dd/MM/yyyy').format(createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'content': content,
      'images': images,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      content: json['content'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      likes: json['likes'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Comment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    double? rating,
    String? content,
    List<String>? images,
    int? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      content: content ?? this.content,
      images: images ?? this.images,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
