class Comment {
  final String id;
  final String userId;
  final String venueId;
  final String userName;
  final String? userAvatar;
  final String content;
  final double rating;
  final List<String>? images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final int helpfulCount;

  Comment({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.rating,
    this.images,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.helpfulCount = 0,
  });

  // Factory constructor từ JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    // Handle both snake_case and camelCase field names
    return Comment(
      id: json['id']?.toString() ?? '',
      userId: (json['user_id'] ?? json['userId'])?.toString() ?? '',
      venueId: (json['venue_id'] ??
                  json['venueId'] ??
                  json['post_id'] ??
                  json['postId'])
              ?.toString() ??
          '',
      userName: json['user_name'] ??
          json['userName'] ??
          json['user']?['name'] ??
          'Anonymous',
      userAvatar:
          json['user_avatar'] ?? json['userAvatar'] ?? json['user']?['avatar'],
      content: json['content'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : (json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : (json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now()),
      isVerified: json['is_verified'] ??
          json['isVerified'] ??
          json['isVerifiedBooking'] ??
          false,
      helpfulCount: json['helpful_count'] ?? json['helpfulCount'] ?? 0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'venue_id': venueId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'content': content,
      'rating': rating,
      'images': images,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_verified': isVerified,
      'helpful_count': helpfulCount,
    };
  }

  // Formatted date for display
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  // Star rating display
  String get starRatingDisplay {
    return '⭐ ${rating.toStringAsFixed(1)}';
  }

  // Copy with method for updating
  Comment copyWith({
    String? id,
    String? userId,
    String? venueId,
    String? userName,
    String? userAvatar,
    String? content,
    double? rating,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    int? helpfulCount,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      venueId: venueId ?? this.venueId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      helpfulCount: helpfulCount ?? this.helpfulCount,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, userName: $userName, rating: $rating, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Comment request model for API
class CommentRequest {
  final String content;
  final double rating;
  final List<String>? imagePaths;

  CommentRequest({
    required this.content,
    required this.rating,
    this.imagePaths,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'rating': rating,
      'image_paths': imagePaths,
    };
  }
}

// Comment response wrapper
class CommentsResponse {
  final List<Comment> comments;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool hasMore;
  final double? averageRating; // ✅ THÊM
  final int? totalComments; // ✅ THÊM

  CommentsResponse({
    required this.comments,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.hasMore,
    this.averageRating, // ✅ THÊM
    this.totalComments, // ✅ THÊM
  });

  factory CommentsResponse.fromJson(Map<String, dynamic> json) {
    // Handle different response formats
    List<dynamic> commentsJson;

    if (json.containsKey('comments')) {
      commentsJson = json['comments'] as List? ?? [];
    } else if (json.containsKey('content')) {
      // Spring Boot Page format
      commentsJson = json['content'] as List? ?? [];
    } else {
      commentsJson = [];
    }

    final comments =
        commentsJson.map((json) => Comment.fromJson(json)).toList();

    // Handle different pagination field names (Spring Boot uses 0-based indexing)
    final currentPage =
        json['current_page'] ?? json['currentPage'] ?? json['number'] ?? 0;

    final totalPages = json['total_pages'] ?? json['totalPages'] ?? 1;

    final totalCount = json['total_count'] ??
        json['totalCount'] ??
        json['totalElements'] ??
        comments.length;

    final hasMore = json['has_more'] ??
        json['hasMore'] ??
        !(json['last'] ?? true); // Spring Boot format

    // ✅ PARSE: averageRating and totalComments from backend
    final averageRating = json['averageRating'] != null
        ? (json['averageRating'] is num
            ? (json['averageRating'] as num).toDouble()
            : null)
        : null;

    final totalComments = json['totalComments'] as int?;

    return CommentsResponse(
      comments: comments,
      currentPage: currentPage is int && currentPage >= 0 ? currentPage + 1 : 1,
      totalPages: totalPages,
      totalCount: totalCount,
      hasMore: hasMore,
      averageRating: averageRating, // ✅ THÊM
      totalComments: totalComments, // ✅ THÊM
    );
  }
}
