import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService;
  List<Message> _messages = [];
  String? _currentChatRoomId;

  ChatProvider(this._chatService);

  List<Message> get messages => _messages;

  void setChatRoom(String chatRoomId, String currentUserId) {
    _currentChatRoomId = chatRoomId;
    _chatService.createNewChatIfNeeded(chatRoomId, currentUserId);
    _loadMessages();
  }

  void _loadMessages() {
    _chatService.getMessages(_currentChatRoomId!).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  Future<void> sendMessage(String text, String senderId) async {
    if (_currentChatRoomId == null) return;
    await _chatService.sendMessage(
      chatRoomId: _currentChatRoomId!,
      text: text,
      senderId: senderId,
    );
  }
}
