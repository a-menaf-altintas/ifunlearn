// FILE: lib/database_helper.dart

import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Singleton pattern to ensure only one instance is used
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Bump the version from 1 to 2
  static const int _dbVersion = 2;

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database and define its location and name
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'ifunlearn.db');
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // <-- Handle upgrades here
    );
  }

  // Create the required tables when the database is first created
  Future _onCreate(Database db, int version) async {
    // Create Profiles table for storing learner's name and age
    await db.execute('''
      CREATE TABLE Profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL
      )
    ''');

    // Create Progress table to log lesson progress and scores
    await db.execute('''
      CREATE TABLE Progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        lesson_id TEXT,
        status TEXT,
        score REAL,
        FOREIGN KEY (profile_id) REFERENCES Profiles (id)
      )
    ''');

    // Since we're at version 2 from the start, also create InteractionLogs
    await db.execute('''
      CREATE TABLE InteractionLogs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        interaction_type TEXT,
        content TEXT,
        timestamp INTEGER,
        FOREIGN KEY (profile_id) REFERENCES Profiles (id)
      )
    ''');
  }

  // Handle upgrades from older versions (e.g., 1) to newer (2, etc.)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create InteractionLogs table if it doesn't exist
      await db.execute('''
        CREATE TABLE InteractionLogs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          profile_id INTEGER,
          interaction_type TEXT,
          content TEXT,
          timestamp INTEGER,
          FOREIGN KEY (profile_id) REFERENCES Profiles (id)
        )
      ''');
    }
  }

  // Insert a new profile
  Future<int> insertProfile(Map<String, dynamic> profile) async {
    Database db = await database;
    return await db.insert('Profiles', profile);
  }

  // Check if a profile with the same name and age already exists
  Future<bool> profileExists(String name, int age) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'Profiles',
      where: 'name = ? AND age = ?',
      whereArgs: [name, age],
    );
    return results.isNotEmpty;
  }

  // Retrieve all profiles
  Future<List<Map<String, dynamic>>> getProfiles() async {
    Database db = await database;
    return await db.query('Profiles');
  }

  // Insert a new interaction log
  Future<int> insertInteractionLog({
    required int profileId,
    required String interactionType,
    required String content,
  }) async {
    final db = await database;
    // We'll store a simple timestamp as milliseconds since epoch
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return await db.insert('InteractionLogs', {
      'profile_id': profileId,
      'interaction_type': interactionType,
      'content': content,
      'timestamp': timestamp,
    });
  }
}
