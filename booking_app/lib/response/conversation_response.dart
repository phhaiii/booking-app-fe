class ConversationResponse {
  final int id;
  final int userId;
  final String userName;
  final String? userAvatar;
  final int adminId;
  final String adminName;
  final String? adminAvatar;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int? unreadCount;
  final DateTime createdAt;

  ConversationResponse({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.adminId,
    required this.adminName,
    this.adminAvatar,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount,
    required this.createdAt,
  });

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'],
      adminId: json['adminId'] ?? 0,
      adminName: json['adminName'] ?? '',
      adminAvatar: json['adminAvatar'],
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'] != null 
        ? DateTime.parse(json['lastMessageAt']) 
        : null,
      unreadCount: json['unreadCount'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  ConversationResponse copyWith({
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return ConversationResponse(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      adminId: adminId,
      adminName: adminName,
      adminAvatar: adminAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt,
    );
  }
}