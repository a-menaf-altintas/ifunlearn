// FILE: lib/profile_creation_screen.dart

import 'package:flutter/material.dart';
import 'database_helper.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({Key? key}) : super(key: key);

  @override
  _ProfileCreationScreenState createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Function to insert the new profile into the database
  void _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      int age = int.parse(_ageController.text.trim());

      // Check if a profile with the same name and age already exists
      bool exists = await DatabaseHelper().profileExists(name, age);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile already exists. Please create a unique name.'),
          ),
        );
        return;
      }

      // If unique, proceed to insert the profile
      Map<String, dynamic> profile = {
        'name': name,
        'age': age,
      };

      int id = await DatabaseHelper().insertProfile(profile);
      print('Profile inserted with id: $id');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile created successfully!')),
      );
      _nameController.clear();
      _ageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name input field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // Age input field
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Button to create profile
              ElevatedButton(
                onPressed: _submitProfile,
                child: const Text('Create Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
