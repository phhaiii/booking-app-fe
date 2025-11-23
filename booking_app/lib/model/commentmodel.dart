class Comment {
  final int id;
  final int postId;
  final int userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final double rating;
  final List<String>? images;
  final bool isVerifiedBooking;
  final int helpfulCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.rating,
    this.images,
    this.isVerifiedBooking = false,
    this.helpfulCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor từ JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      postId: json['postId'] ?? json['post_id'] ?? 0,
      userId: json['userId'] ?? json['user_id'] ?? 0,
      userName: json['userName'] ??
          json['user_name'] ??
          json['user']?['fullName'] ??
          'Anonymous',
      userAvatar: json['userAvatar'] ??
          json['user_avatar'] ??
          json['user']?['avatarUrl'],
      content: json['content'] ?? '',
      rating: (json['rating'] ?? 5.0).toDouble(),
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      isVerifiedBooking:
          json['isVerifiedBooking'] ?? json['is_verified_booking'] ?? false,
      helpfulCount: json['helpfulCount'] ?? json['helpful_count'] ?? 0,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now()),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'content': content,
      'rating': rating,
      'images': images,
      'isVerifiedBooking': isVerifiedBooking,
      'helpfulCount': helpfulCount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Getter for backward compatibility
  String get venueId => postId.toString();
  bool get isVerified => isVerifiedBooking;

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
    int? id,
    int? postId,
    int? userId,
    String? userName,
    String? userAvatar,
    String? content,
    double? rating,
    List<String>? images,
    bool? isVerifiedBooking,
    int? helpfulCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      images: images ?? this.images,
      isVerifiedBooking: isVerifiedBooking ?? this.isVerifiedBooking,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      averageRating: averageRating, 
      totalComments: totalComments, 
    );
  }
}
