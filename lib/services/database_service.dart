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
        enableVibration INTEGER,
        enableCallAlert INTEGER,
        enableAlarm INTEGER,
        muteNotifications INTEGER,
        selectedInterval INTEGER,
        veryLow REAL,
        veryHigh REAL,
        bigDrop REAL,
        bigRise REAL
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

// ✅ Get settings with default fallback
  Future<Map<String, dynamic>> getSettings() async {
    final db = await database;
    final result = await db.query('settings', where: 'id = ?', whereArgs: [1]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      // 🔹 If settings are missing, insert default settings
      print("⚠️ No settings found. Inserting default settings...");
      await updateSettings(
        enableVibration: false,
        enableCallAlert: false,
        enableAlarm: false,
        muteNotifications: true,
        selectedInterval: 15,
        veryLow: 60.0,
        veryHigh: 200.0,
        bigDrop: 15.0,
        bigRise: 25.0,
      );

      return {
        'enableVibration': 0,
        'enableCallAlert': 0,
        'enableAlarm': 0,
        'muteNotifications': 1,
        'selectedInterval': 15,
        'veryLow': 60.0,
        'veryHigh': 200.0,
        'bigDrop': 15.0,
        'bigRise': 25.0,
      };
    }
  }

// ✅ Insert or Update settings properly
  Future<void> updateSettings({
    required bool enableVibration,
    required bool enableCallAlert,
    required bool enableAlarm,
    required bool muteNotifications,
    required int selectedInterval,
    required double veryLow,
    required double veryHigh,
    required double bigDrop,
    required double bigRise,
  }) async {
    final db = await database;

    // 🔹 Check if settings already exist
    final existingSettings =
        await db.query('settings', where: 'id = ?', whereArgs: [1]);

    if (existingSettings.isNotEmpty) {
      // ✅ Update existing settings
      await db.update(
        'settings',
        {
          'enableVibration': enableVibration ? 1 : 0,
          'enableCallAlert': enableCallAlert ? 1 : 0,
          'enableAlarm': enableAlarm ? 1 : 0,
          'muteNotifications': muteNotifications ? 1 : 0,
          'selectedInterval': selectedInterval,
          'veryLow': veryLow,
          'veryHigh': veryHigh,
          'bigDrop': bigDrop,
          'bigRise': bigRise,
        },
        where: 'id = ?',
        whereArgs: [1],
      );
    } else {
      // ✅ Insert default settings if not found
      await db.insert(
        'settings',
        {
          'id': 1, // 🔹 Ensure only ONE settings row exists
          'enableVibration': enableVibration ? 1 : 0,
          'enableCallAlert': enableCallAlert ? 1 : 0,
          'enableAlarm': enableAlarm ? 1 : 0,
          'muteNotifications': muteNotifications ? 1 : 0,
          'selectedInterval': selectedInterval,
          'veryLow': veryLow,
          'veryHigh': veryHigh,
          'bigDrop': bigDrop,
          'bigRise': bigRise,
        },
      );
    }

    print("✅ Settings saved to database");
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
  Future<List<Map<String, dynamic>>> getGlucoseTrendData(String date) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT 
      strftime('%H:%M', timestamp) AS time,
      glucose_level AS value
    FROM glucose_readings
    WHERE DATE(timestamp) = ?
    ORDER BY timestamp ASC
  ''', [date]);

    if (result.isNotEmpty) {
      return result;
    } else {
      print("⚠️ No data found for $date. Using sample data.");
      return [
        {'time': '08:00', 'value': 90},
        {'time': '10:00', 'value': 120},
        {'time': '12:00', 'value': 160},
        {'time': '14:00', 'value': 110},
        {'time': '16:00', 'value': 65},
        {'time': '18:00', 'value': 100},
        {'time': '20:00', 'value': 190},
      ];
    }
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
