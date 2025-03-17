import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text('Register Page'),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  final result = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: 'test@gmail.com',
                    password: '123456',
                  );
                  print(result);
                },
                child: Text('Register'))
          ],
        ),
      ),
    );
  }
}
