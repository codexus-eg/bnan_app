import 'dart:async';

import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  SocketService() {
    SessionManager.instance.addAccessTokenChangeListener(_updateAuthToken);
  }

  Socket? _socket;
  Future<void>? _connectFuture;
  Completer<void>? _connectionCompleter;

  Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  void _updateAuthToken(String? token) {
    if (token?.isNotEmpty == true) _socket?.auth = {'token': token};
  }

  Future<void> connect() {
    if (_socket?.connected == true) return Future<void>.value();

    final current = _connectFuture;
    if (current != null) return current;
    final attempt = _connect();
    _connectFuture = attempt;
    return attempt.whenComplete(() {
      if (identical(_connectFuture, attempt)) _connectFuture = null;
    });
  }

  Future<void> _connect() async {
    if (_socket?.connected == true) return;

    final token = await SessionManager.instance.getAccessToken();

    if (token == null || token.isEmpty) {
      throw StateError('Cannot connect chat socket without an access token.');
    }

    if (_socket == null) {
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
    }

    if (_socket?.connected == true) return;

    final completer = Completer<void>();
    _connectionCompleter = completer;

    _socket?.connect();

    try {
      await completer.future.timeout(const Duration(seconds: 20));
    } finally {
      if (identical(_connectionCompleter, completer)) {
        _connectionCompleter = null;
      }
    }
  }

  void _registerConnectionListeners() {
    _socket?.onConnect((_) {
      debugPrint('Socket connected: ${_socket?.id}');
      final completer = _connectionCompleter;
      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }
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

  VoidCallback listenToJoinedRoom(void Function(String roomId) onJoined) {
    return _listen('joinedRoom', (data) {
      onJoined(data.toString());
    });
  }

  VoidCallback listenToLeftRoom(void Function(String roomId) onLeft) {
    return _listen('leftRoom', (data) {
      onLeft(data.toString());
    });
  }

  VoidCallback listenToNewMessage(
    void Function(ChatMessageModel message) onNewMessage,
  ) {
    return _listen('newMessage', (data) {
      try {
        final json = Map<String, dynamic>.from(data);

        final message = ChatMessageModel.fromJson(json);

        onNewMessage(message);
      } catch (error) {
        debugPrint('New message parsing error: $error');
      }
    });
  }

  VoidCallback listenToMessageEdited(
    void Function(ChatMessageModel message) onMessageEdited,
  ) {
    return _listen('messageEdited', (data) {
      try {
        final json = Map<String, dynamic>.from(data);

        final message = ChatMessageModel.fromJson(json);

        onMessageEdited(message);
      } catch (error) {
        debugPrint('Edited message parsing error: $error');
      }
    });
  }

  VoidCallback listenToMessageDeleted(
    void Function(String messageId) onMessageDeleted,
  ) {
    return _listen('messageDeleted', (data) {
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

  VoidCallback listenToNotification(
    void Function(Map<String, dynamic> notification) onNotification,
  ) {
    return _listen('notification', (data) {
      try {
        final notification = Map<String, dynamic>.from(data);

        onNotification(notification);
      } catch (error) {
        debugPrint('Notification parsing error: $error');
      }
    });
  }

  VoidCallback listenToReconnect(VoidCallback onReconnect) {
    final socket = _socket;
    if (socket == null) return () {};

    void listener(dynamic _) => onReconnect();
    socket.onReconnect(listener);
    return () => socket.io.off('reconnect', listener);
  }

  VoidCallback _listen(String event, void Function(dynamic data) listener) {
    final socket = _socket;
    if (socket == null) return () {};

    socket.on(event, listener);
    return () => socket.off(event, listener);
  }

  void disconnect() {
    final completer = _connectionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.completeError(StateError('Socket connection cancelled.'));
    }
    _connectionCompleter = null;
    _connectFuture = null;
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
