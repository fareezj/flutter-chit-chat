// lib/screens/users_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../route_generator.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select User')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          final users =
              snapshot.data!.docs.where((doc) => doc.id != currentUserId);

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users.elementAt(index);
              return ListTile(
                title: Text(user['email']),
                onTap: () {
                  final chatRoomId = _generateChatId(currentUserId!, user.id);

                  Navigator.pushNamed(
                    context,
                    RouteGenerator.chatPage,
                    arguments: {
                      'chatRoomId': chatRoomId,
                      'otherUserId': user.id,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _generateChatId(String a, String b) {
    final sortedIds = [a, b]..sort();
    return sortedIds.join('_');
  }
}
