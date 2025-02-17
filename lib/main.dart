// FILE: lib/main.dart

import 'package:flutter/material.dart';
import 'profile_selection_screen.dart';

void main() {
  runApp(const iFunLearnApp());
}

class iFunLearnApp extends StatelessWidget {
  const iFunLearnApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      title: 'iFunLearn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfileSelectionScreen(),
    );
  }
}
