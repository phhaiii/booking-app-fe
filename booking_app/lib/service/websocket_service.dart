import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:booking_app/service/storage_service.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String userId;
  final Function(Map<String, dynamic>) onMessageReceived;
  final Function(String)? onConnectionStatusChanged;
  final Function(String)? onError;

  static const String baseUrl = 'ws://10.0.2.2:8089';
  bool _isConnected = false;

  WebSocketService({
    required this.userId,
    required this.onMessageReceived,
    this.onConnectionStatusChanged,
    this.onError,
  });

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      print('Connecting to WebSocket...');

      // Lấy token để authentication
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Kết nối WebSocket với authentication header
      final uri = Uri.parse('$baseUrl/ws');
      _channel = IOWebSocketChannel.connect(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Lắng nghe tin nhắn
      _channel!.stream.listen(
        (data) {
          print('Received message: $data');
          try {
            final message = jsonDecode(data);
            onMessageReceived(message);
          } catch (e) {
            print('Error parsing message: $e');
            onError?.call('Error parsing message: $e');
          }
        },
        onDone: () {
          print('WebSocket connection closed');
          _isConnected = false;
          onConnectionStatusChanged?.call('disconnected');
        },
        onError: (error) {
          print('WebSocket error: $error');
          _isConnected = false;
          onError?.call('Connection error: $error');
          onConnectionStatusChanged?.call('error');
        },
      );

      _isConnected = true;
      onConnectionStatusChanged?.call('connected');
      print('WebSocket connected successfully');

      // Subscribe to user's message queue
      _subscribeToUserMessages();
    } catch (e) {
      print('Failed to connect WebSocket: $e');
      _isConnected = false;
      onError?.call('Failed to connect: $e');
      onConnectionStatusChanged?.call('error');
    }
  }

  void _subscribeToUserMessages() {
    final subscribeMessage = {
      'type': 'SUBSCRIBE',
      'destination': '/user/$userId/queue/messages',
    };

    _channel?.sink.add(jsonEncode(subscribeMessage));
    print('Subscribed to user messages for user: $userId');
  }

  void sendMessage({
    required int adminId,
    required String messageText,
    required String messageType,
    String? fileUrl,
  }) {
    if (!_isConnected || _channel == null) {
      print('❌ WebSocket not connected');
      onError?.call('Not connected to chat server');
      return;
    }

    final message = {
      'type': 'SEND',
      'destination': '/app/chat.send',
      'body': {
        'adminId': adminId,
        'messageText': messageText,
        'messageType': messageType,
        if (fileUrl != null) 'fileUrl': fileUrl,
      },
    };

    try {
      _channel!.sink.add(jsonEncode(message));
      print('Message sent: $messageText');
    } catch (e) {
      print('Error sending message: $e');
      onError?.call('Failed to send message: $e');
    }
  }

  void markAsRead(int conversationId) {
    if (!_isConnected || _channel == null) return;

    final message = {
      'type': 'SEND',
      'destination': '/app/chat.read',
      'body': conversationId,
    };

    try {
      _channel!.sink.add(jsonEncode(message));
      print('Marked conversation $conversationId as read');
    } catch (e) {
      print('Error marking as read: $e');
    }
  }

  void disconnect() {
    print('Disconnecting WebSocket...');
    _isConnected = false;
    _channel?.sink.close();
    _channel = null;
    onConnectionStatusChanged?.call('disconnected');
  }

  // Reconnect method
  Future<void> reconnect() async {
    disconnect();
    await Future.delayed(const Duration(seconds: 2));
    await connect();
  }
}
