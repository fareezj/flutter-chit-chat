import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import 'package:flutter/widgets.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Message> _messages = [];
  String? _currentChatRoomId;
  String? _errorMessage;
  StreamSubscription<QuerySnapshot>? _messageSubscription;

  ChatProvider();

  List<Message> get messages => _messages;
  String? get errorMessage => _errorMessage;

  void setChatRoom(String chatRoomId) {
    _messageSubscription?.cancel();
    _currentChatRoomId = chatRoomId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messageSubscription = _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        _messages =
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList();
        notifyListeners();
      });
    });
  }

  Future<void> sendMessage(String text, String senderId) async {
    if (_currentChatRoomId == null) return;
    try {
      await _firestore
          .collection('chatRooms')
          .doc(_currentChatRoomId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _errorMessage = 'Failed to send message: ${e.toString()}';
    }
  }
}
