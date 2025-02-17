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
      version: 1,
      onCreate: _onCreate,
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
}
