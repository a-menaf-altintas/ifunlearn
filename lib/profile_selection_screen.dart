// FILE: lib/profile_selection_screen.dart

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'profile_creation_screen.dart';
import 'tutor_home_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({Key? key}) : super(key: key);

  @override
  _ProfileSelectionScreenState createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  List<Map<String, dynamic>> profiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  // Retrieve all profiles from the database
  void _loadProfiles() async {
    final fetchedProfiles = await DatabaseHelper().getProfiles();
    setState(() {
      profiles = fetchedProfiles;
    });
  }

  // Navigate to TutorHomeScreen with the selected profile
  void _selectProfile(Map<String, dynamic> profile) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TutorHomeScreen(profile: profile)),
    );
  }

  // Navigate to ProfileCreationScreen to add a new profile
  void _addNewProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileCreationScreen()),
    ).then((_) => _loadProfiles());
  }

  // Show all profiles in a bottom sheet
  void _showAllProfilesSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: ListView.separated(
            itemCount: profiles.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return ListTile(
                title: Text(profile['name']),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _selectProfile(profile);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int displayCount = (profiles.length <= 3) ? profiles.length : 3;
    final bool hasMoreProfiles = profiles.length > 3;

    return Scaffold(
      body: SafeArea(
        child: Center(
          // SingleChildScrollView + a centered column to handle any overflow
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Profiles',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // If no profiles, show a message
                if (profiles.isEmpty) ...[
                  Text(
                    'No profiles found.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ]
                // If we have profiles, display up to 3
                else ...[
                  for (int i = 0; i < displayCount; i++) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectProfile(profiles[i]),
                      child: Text(
                        profiles[i]['name'],
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  // If more than 3 profiles, show "Show All Profiles"
                  if (hasMoreProfiles) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _showAllProfilesSheet,
                      child: const Text('Show All Profiles'),
                    ),
                  ],
                ],
                const SizedBox(height: 24),

                // "Add a new profile" button
                ElevatedButton.icon(
                  onPressed: _addNewProfile,
                  icon: const Icon(Icons.add),
                  label: const Text('Add a new profile'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
