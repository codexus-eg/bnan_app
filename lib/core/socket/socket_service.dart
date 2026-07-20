import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  Socket? _socket;

  Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    if (_socket?.connected == true) return;

    final token = await SessionManager.instance.getAccessToken();

    if (token == null || token.isEmpty) return;

    _socket = io(
      EndPoints.socketUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );

    _registerConnectionListeners();

    _socket?.connect();
  }

  void _registerConnectionListeners() {
    _socket?.onConnect((_) {
      debugPrint('Socket connected: ${_socket?.id}');
    });

    _socket?.onDisconnect((_) {
      debugPrint('Socket disconnected');
    });

    _socket?.onConnectError((error) {
      debugPrint('Socket connection error: $error');
    });

    _socket?.onError((error) {
      debugPrint('Socket error: $error');
    });

    _socket?.onReconnect((attempt) {
      debugPrint('Socket reconnected after attempt: $attempt');
    });
  }

  void joinRoom(String roomId) {
    if (!isConnected) return;

    _socket?.emit('joinRoom', roomId);
  }

  void leaveRoom(String roomId) {
    if (!isConnected) return;

    _socket?.emit('leaveRoom', roomId);
  }

  void listenToJoinedRoom(void Function(String roomId) onJoined) {
    _socket?.off('joinedRoom');

    _socket?.on('joinedRoom', (data) {
      onJoined(data.toString());
    });
  }

  void listenToLeftRoom(void Function(String roomId) onLeft) {
    _socket?.off('leftRoom');

    _socket?.on('leftRoom', (data) {
      onLeft(data.toString());
    });
  }

  void listenToNewMessage(
    void Function(ChatMessageModel message) onNewMessage,
  ) {
    _socket?.off('newMessage');

    _socket?.on('newMessage', (data) {
      try {
        final json = Map<String, dynamic>.from(data);

        final message = ChatMessageModel.fromJson(json);

        onNewMessage(message);
      } catch (error) {
        debugPrint('New message parsing error: $error');
      }
    });
  }

  void listenToMessageEdited(
    void Function(ChatMessageModel message) onMessageEdited,
  ) {
    _socket?.off('messageEdited');

    _socket?.on('messageEdited', (data) {
      try {
        final json = Map<String, dynamic>.from(data);

        final message = ChatMessageModel.fromJson(json);

        onMessageEdited(message);
      } catch (error) {
        debugPrint('Edited message parsing error: $error');
      }
    });
  }

  void listenToMessageDeleted(
    void Function(String messageId) onMessageDeleted,
  ) {
    _socket?.off('messageDeleted');

    _socket?.on('messageDeleted', (data) {
      try {
        final json = Map<String, dynamic>.from(data);

        final messageId = json['messageId']?.toString();

        if (messageId == null || messageId.isEmpty) return;

        onMessageDeleted(messageId);
      } catch (error) {
        debugPrint('Deleted message parsing error: $error');
      }
    });
  }

  void listenToNotification(
    void Function(Map<String, dynamic> notification) onNotification,
  ) {
    _socket?.off('notification');

    _socket?.on('notification', (data) {
      try {
        final notification = Map<String, dynamic>.from(data);

        onNotification(notification);
      } catch (error) {
        debugPrint('Notification parsing error: $error');
      }
    });
  }

  void removeChatListeners() {
    _socket?.off('joinedRoom');
    _socket?.off('leftRoom');
    _socket?.off('newMessage');
    _socket?.off('messageEdited');
    _socket?.off('messageDeleted');
  }

  void removeNotificationListener() {
    _socket?.off('notification');
  }

  void disconnect() {
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
