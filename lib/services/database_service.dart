import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/reminder.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;
  SharedPreferences? _prefs;

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('Database not supported on web');
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'plant_care.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plantId INTEGER,
        title TEXT,
        description TEXT,
        scheduledTime TEXT,
        isActive INTEGER
      )
    ''');
  }

  Future<int> insertReminder(Reminder reminder) async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      final prefs = await this.prefs;
      List<String> remindersJson = prefs.getStringList('reminders') ?? [];
      int newId = DateTime.now().millisecondsSinceEpoch; // Simple ID generation
      Reminder newReminder = reminder.copyWith(id: newId);
      remindersJson.add(jsonEncode(newReminder.toMap()));
      await prefs.setStringList('reminders', remindersJson);
      return newId;
    } else {
      Database db = await database;
      return await db.insert('reminders', reminder.toMap());
    }
  }

  Future<List<Reminder>> getReminders() async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      final prefs = await this.prefs;
      List<String> remindersJson = prefs.getStringList('reminders') ?? [];
      return remindersJson.map((jsonStr) {
        Map<String, dynamic> map = jsonDecode(jsonStr);
        return Reminder.fromMap(map);
      }).toList();
    } else {
      Database db = await database;
      List<Map<String, dynamic>> maps = await db.query('reminders');
      return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
    }
  }

  Future<int> updateReminder(Reminder reminder) async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      final prefs = await this.prefs;
      List<String> remindersJson = prefs.getStringList('reminders') ?? [];
      int index = remindersJson.indexWhere((jsonStr) {
        Map<String, dynamic> map = jsonDecode(jsonStr);
        return map['id'] == reminder.id;
      });
      if (index != -1) {
        remindersJson[index] = jsonEncode(reminder.toMap());
        await prefs.setStringList('reminders', remindersJson);
      }
      return 1;
    } else {
      Database db = await database;
      return await db.update(
        'reminders',
        reminder.toMap(),
        where: 'id = ?',
        whereArgs: [reminder.id],
      );
    }
  }

  Future<int> deleteReminder(int id) async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      final prefs = await this.prefs;
      List<String> remindersJson = prefs.getStringList('reminders') ?? [];
      remindersJson.removeWhere((jsonStr) {
        Map<String, dynamic> map = jsonDecode(jsonStr);
        return map['id'] == id;
      });
      await prefs.setStringList('reminders', remindersJson);
      return 1;
    } else {
      Database db = await database;
      return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
    }
  }
}
