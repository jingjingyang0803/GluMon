import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'glucose.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE glucose_readings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        glucose_level REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alert_high REAL NOT NULL,
        alert_low REAL NOT NULL,
        retrieval_interval INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE devices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sensor_id TEXT NOT NULL,
        battery_level INTEGER NOT NULL,
        connection_status TEXT NOT NULL
      )
    ''');
  }

  // Insert glucose reading
  Future<int> insertGlucoseReading(double glucoseLevel) async {
    final db = await database;
    return await db.insert(
      'glucose_readings',
      {
        'timestamp': DateTime.now().toIso8601String(),
        'glucose_level': glucoseLevel,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch glucose readings
  Future<List<Map<String, dynamic>>> getGlucoseReadings() async {
    final db = await database;
    return await db.query(
      'glucose_readings',
      orderBy: 'timestamp DESC',
    );
  }

  // Fetch daily min, max, and avg glucose levels
  Future<List<Map<String, dynamic>>> getDailyMinMaxAvg() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        DATE(timestamp) AS date,
        MIN(glucose_level) AS min_glucose,
        MAX(glucose_level) AS max_glucose,
        AVG(glucose_level) AS avg_glucose
      FROM glucose_readings
      GROUP BY DATE(timestamp)
      ORDER BY DATE(timestamp) DESC
    ''');
  }

  // Fetch glucose readings for a specific day (for trendline)
  Future<List<Map<String, dynamic>>> getDailyTrendData(String date) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT timestamp, glucose_level 
      FROM glucose_readings 
      WHERE DATE(timestamp) = ? 
      ORDER BY timestamp ASC
    ''', [date]);
  }

  // Insert or update settings
  Future<int> updateSettings(double high, double low, int interval) async {
    final db = await database;
    return await db.insert(
      'settings',
      {
        'id': 1,
        'alert_high': high,
        'alert_low': low,
        'retrieval_interval': interval,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get settings
  Future<Map<String, dynamic>?> getSettings() async {
    final db = await database;
    final result = await db.query('settings', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first : null;
  }

  // Insert or update device info
  Future<int> updateDevice(String sensorId, int battery, String status) async {
    final db = await database;
    return await db.insert(
      'devices',
      {
        'id': 1,
        'sensor_id': sensorId,
        'battery_level': battery,
        'connection_status': status,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get device status
  Future<Map<String, dynamic>?> getDeviceStatus() async {
    final db = await database;
    final result = await db.query('devices', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first : null;
  }

  // Close database
  Future<void> closeDatabase() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
