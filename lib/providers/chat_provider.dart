import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Message> _messages = [];
  String? _currentChatRoomId;
  String? _errorMessage;

  ChatProvider();

  List<Message> get messages => _messages;
  String? get errorMessage => _errorMessage;

  void setChatRoom(String chatRoomId, String otherUserId) {
    try {
      _currentChatRoomId = chatRoomId;
      _loadMessages();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to initialize chat: ${e.toString()}';
    }
    notifyListeners();
  }

  void _loadMessages() {
    _firestore
        .collection('chatRooms')
        .doc(_currentChatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      _messages = querySnapshot.docs
          .map((doc) => Message.fromJson(doc.data()))
          .toList();
      notifyListeners();
    });
  }

  Future<void> sendMessage(String text, String senderId) async {
    if (_currentChatRoomId == null) return;
    await _firestore
        .collection('chatRooms')
        .doc(_currentChatRoomId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
