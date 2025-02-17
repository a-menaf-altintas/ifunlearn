// FILE: lib/tutor_home_screen.dart

import 'package:flutter/material.dart';
import 'tutor_interactive_screen.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${profile['name']}! Your age is ${profile['age']}.',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the interactive tutor session
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TutorInteractiveScreen(profile: profile),
                  ),
                );
              },
              child: const Text('Launch Interactive Tutor'),
            ),
          ],
        ),
      ),
    );
  }
}
