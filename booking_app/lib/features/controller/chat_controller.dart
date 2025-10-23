import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/service/websocket_service.dart';
import 'package:booking_app/service/api.dart';
import 'package:booking_app/service/storage_service.dart';
import 'package:booking_app/models/message_response.dart';
import 'package:booking_app/models/conversation_response.dart';
import 'package:booking_app/models/api_response.dart';

class ChatController extends GetxController {
  late WebSocketService _webSocketService;
  
  // Observable variables
  final messages = <MessageResponse>[].obs;
  final conversations = <ConversationResponse>[].obs;
  final isLoading = false.obs;
  final isConnected = false.obs;
  final connectionStatus = 'disconnected'.obs;
  final currentConversationId = Rx<int?>(null);
  
  // Controllers
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  
  // Current user info
  String? currentUserId;
  String? currentUserEmail;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeUser();
    await _initializeWebSocket();
    await loadConversations();
  }

  Future<void> _initializeUser() async {
    currentUserId = await StorageService.getUserId();
    currentUserEmail = await StorageService.getEmail();
    print('👤 Current user: $currentUserId ($currentUserEmail)');
  }

  Future<void> _initializeWebSocket() async {
    if (currentUserId == null) {
      print(' No user ID found');
      return;
    }

    _webSocketService = WebSocketService(
      userId: currentUserId!,
      onMessageReceived: _handleNewMessage,
      onConnectionStatusChanged: _handleConnectionStatusChanged,
      onError: _handleWebSocketError,
    );

    await _webSocketService.connect();
  }

  void _handleNewMessage(Map<String, dynamic> messageData) {
    try {
      final message = MessageResponse.fromJson(messageData);
      
      // Add message to current conversation if it matches
      if (currentConversationId.value == message.conversationId) {
        messages.add(message);
        _scrollToBottom();
      }
      
      // Update conversation list
      _updateConversationWithNewMessage(message);
      
      print('New message received: ${message.messageText}');
    } catch (e) {
      print(' Error handling new message: $e');
    }
  }

  void _handleConnectionStatusChanged(String status) {
    connectionStatus.value = status;
    isConnected.value = status == 'connected';
    print(' Connection status: $status');
    
    if (status == 'connected') {
      Get.snackbar(
        'Kết nối thành công',
        'Đã kết nối tới chat server',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 2),
      );
    } else if (status == 'error') {
      Get.snackbar(
        'Lỗi kết nối',
        'Không thể kết nối tới chat server',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
      );
    }
  }

  void _handleWebSocketError(String error) {
    print('WebSocket error: $error');
    Get.snackbar(
      'Lỗi chat',
      error,
      backgroundColor: Colors.transparent,
      colorText: Colors.red,
    );
  }

  // Load conversations from API
  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      
      final response = await ApiService.get('/chat/conversations');
      final apiResponse = ApiResponse<List<ConversationResponse>>.fromJson(
        response,
        (data) => (data as List).map((item) => ConversationResponse.fromJson(item)).toList(),
      );

      if (apiResponse.success && apiResponse.data != null) {
        conversations.value = apiResponse.data!;
        print('✅ Loaded ${conversations.length} conversations');
      }
    } catch (e) {
      print('Error loading conversations: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách hội thoại',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load messages for a conversation
  Future<void> loadMessages(int conversationId) async {
    try {
      isLoading.value = true;
      currentConversationId.value = conversationId;
      
      final response = await ApiService.get('/chat/conversations/$conversationId/messages');
      final apiResponse = ApiResponse<List<MessageResponse>>.fromJson(
        response,
        (data) => (data as List).map((item) => MessageResponse.fromJson(item)).toList(),
      );

      if (apiResponse.success && apiResponse.data != null) {
        messages.value = apiResponse.data!.reversed.toList(); // Reverse to show oldest first
        _scrollToBottom();
        
        // Mark messages as read
        markAsRead(conversationId);
        
        print('Loaded ${messages.length} messages');
      }
    } catch (e) {
      print('Error loading messages: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải tin nhắn',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Send message
  void sendMessage(int adminId, {String? fileUrl}) {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty) return;

    if (!isConnected.value) {
      Get.snackbar(
        'Lỗi',
        'Không có kết nối tới chat server',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
      );
      return;
    }

    _webSocketService.sendMessage(
      adminId: adminId,
      messageText: messageText,
      messageType: fileUrl != null ? 'FILE' : 'TEXT',
      fileUrl: fileUrl,
    );

    messageController.clear();
  }

  // Mark conversation as read
  void markAsRead(int conversationId) {
    if (isConnected.value) {
      _webSocketService.markAsRead(conversationId);
    }
  }

  // Get or create conversation with admin
  Future<ConversationResponse?> getOrCreateConversation(int adminId) async {
    try {
      isLoading.value = true;
      
      final response = await ApiService.post(
        '/chat/conversations', 
        body: {'adminId': adminId}
      );
      
      final apiResponse = ApiResponse<ConversationResponse>.fromJson(
        response,
        (data) => ConversationResponse.fromJson(data),
      );

      if (apiResponse.success && apiResponse.data != null) {
        // Add to conversations list if not exists
        final existingIndex = conversations.indexWhere(
          (conv) => conv.id == apiResponse.data!.id
        );
        
        if (existingIndex == -1) {
          conversations.insert(0, apiResponse.data!);
        } else {
          conversations[existingIndex] = apiResponse.data!;
        }
        
        return apiResponse.data;
      }
    } catch (e) {
      print('Error getting/creating conversation: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tạo cuộc hội thoại',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  // Helper methods
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _updateConversationWithNewMessage(MessageResponse message) {
    final index = conversations.indexWhere(
      (conv) => conv.id == message.conversationId
    );
    
    if (index != -1) {
      final updatedConv = conversations[index].copyWith(
        lastMessage: message.messageText,
        lastMessageAt: message.createdAt,
        unreadCount: currentConversationId.value == message.conversationId 
          ? 0 
          : (conversations[index].unreadCount ?? 0) + 1,
      );
      
      conversations[index] = updatedConv;
      
      // Move to top of list
      conversations.removeAt(index);
      conversations.insert(0, updatedConv);
    }
  }

  // Reconnect WebSocket
  Future<void> reconnect() async {
    await _webSocketService.reconnect();
  }

  @override
  void onClose() {
    _webSocketService.disconnect();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}