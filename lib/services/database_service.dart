import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/reminder.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
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
    Database db = await database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getReminders() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
  }

  Future<int> updateReminder(Reminder reminder) async {
    Database db = await database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteReminder(int id) async {
    Database db = await database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
