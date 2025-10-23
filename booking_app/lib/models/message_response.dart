class MessageResponse {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderName;
  final String? senderAvatar;
  final String messageText;
  final String messageType;
  final String? fileUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  MessageResponse({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.messageText,
    required this.messageType,
    this.fileUrl,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      id: json['id'] ?? 0,
      conversationId: json['conversationId'] ?? 0,
      senderId: json['senderId'] ?? 0,
      senderName: json['senderName'] ?? '',
      senderAvatar: json['senderAvatar'],
      messageText: json['messageText'] ?? '',
      messageType: json['messageType'] ?? 'TEXT',
      fileUrl: json['file_url'],
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'messageText': messageText,
      'messageType': messageType,
      'file_url': fileUrl,
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}