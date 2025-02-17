import 'package:flutter/material.dart';

class TutorHomeScreen extends StatelessWidget {
  final Map<String, dynamic> profile;

  const TutorHomeScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor Home'),
      ),
      body: Center(
        child: Text(
          'Welcome, ${profile['name']}! Your age is ${profile['age']}.',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
