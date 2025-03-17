// lib/screens/users_screen.dart
import 'package:chit_chat/models/user.dart';
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
              if (user['name'] == null) {
                return ListTile(
                  title: Text('Invalid user data',
                      style: TextStyle(color: Colors.red)),
                );
              }
              return ListTile(
                leading: CircleAvatar(child: Text(user['name'][0])),
                title: Text(user['name']),
                onTap: () {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  final chatRoomId = _generateChatId(currentUser!.uid, user.id);

                  Navigator.pushNamed(
                    context,
                    RouteGenerator.chatPage,
                    arguments: {
                      'user': AppUser(
                          name: user['name'],
                          email: user['email'],
                          id: user.id),
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
