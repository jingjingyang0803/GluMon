import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  // ✅ Setup Logger
  final Logger _log = Logger('DatabaseService');

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  /// **Get Database Instance**
  Future<Database> get database async {
    if (_database != null) {
      _log.info("✅ Using existing database connection.");
      return _database!;
    }

    _log.info("📂 Initializing database...");
    _database = await _initDatabase();
    return _database!;
  }

  /// **Initialize Database**
  Future<Database> _initDatabase() async {
    try {
      final path = join(await getDatabasesPath(), 'glucose.db');
      _log.info("📂 Database file path: $path");

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {
          _log.info("🟢 Database opened successfully.");
        },
      );
    } catch (e) {
      _log.severe("❌ Database initialization error: $e");
      rethrow;
    }
  }

  /// **Create Tables**
  Future<void> _onCreate(Database db, int version) async {
    try {
      _log.info("🛠️ Creating database tables...");

      await db.execute('''
        CREATE TABLE glucose_readings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          timestamp TEXT NOT NULL,
          glucose_level REAL NOT NULL,
          temperature REAL NOT NULL,
          humidity REAL NOT NULL
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

      _log.info("✅ Database tables created successfully.");
    } catch (e) {
      _log.severe("❌ Error creating tables: $e");
    }
  }

  /// **Check Database Connection**
  Future<bool> isDatabaseConnected() async {
    try {
      final db = await database;
      bool isConnected = db.isOpen;
      _log.info("🔗 Database connection status: $isConnected");
      return isConnected;
    } catch (e) {
      _log.severe("❌ Database connection check failed: $e");
      return false;
    }
  }

  /// **Fetch Settings with Default Fallback**
  Future<Map<String, dynamic>> getSettings() async {
    try {
      _log.info("📥 Fetching settings...");
      final db = await database;
      final result =
          await db.query('settings', where: 'id = ?', whereArgs: [1]);

      if (result.isNotEmpty) {
        _log.info("✅ Settings retrieved: ${result.first}");
        return result.first;
      } else {
        _log.warning("⚠️ No settings found. Inserting default settings...");
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
    } catch (e) {
      _log.severe("❌ Error fetching settings: $e");
      return {};
    }
  }

  /// **Insert or Update Settings**
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
    try {
      _log.info("🛠️ Updating settings...");
      final db = await database;

      final existingSettings =
          await db.query('settings', where: 'id = ?', whereArgs: [1]);

      if (existingSettings.isNotEmpty) {
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
        _log.info("✅ Settings updated.");
      } else {
        await db.insert(
          'settings',
          {
            'id': 1,
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
        _log.info("✅ Default settings inserted.");
      }
    } catch (e) {
      _log.severe("❌ Error updating settings: $e");
    }
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

  /// **Insert or Update Device Info**
  Future<int> updateDevice(String sensorId, int battery, String status) async {
    try {
      _log.info(
          "🔋 Updating device: Sensor ID: $sensorId, Battery: $battery%, Status: $status");
      final db = await database;

      final id = await db.insert(
        'devices',
        {
          'id': 1,
          'sensor_id': sensorId,
          'battery_level': battery,
          'connection_status': status,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _log.info("✅ Device info updated successfully.");
      return id;
    } catch (e) {
      _log.severe("❌ Error updating device info: $e");
      return 0;
    }
  }

  /// **Fetch Device Status**
  Future<Map<String, dynamic>?> getDeviceStatus() async {
    try {
      final db = await database;
      _log.info("🔍 Fetching device status...");

      final result = await db.query('devices', where: 'id = ?', whereArgs: [1]);

      if (result.isNotEmpty) {
        _log.info("🔌 Device status: ${result.first}");
        return result.first;
      } else {
        _log.warning("⚠️ No device status found.");
        return null;
      }
    } catch (e) {
      _log.severe("❌ Error fetching device status: $e");
      return null;
    }
  }

  /// **Close Database**
  Future<void> closeDatabase() async {
    try {
      final db = await _database;
      if (db != null) {
        await db.close();
        _log.info("🔴 Database connection closed.");
      }
    } catch (e) {
      _log.severe("❌ Error closing database: $e");
    }
  }

  /// **Save Glucose Data**
  Future<void> saveGlucoseReading(Map<String, dynamic> data) async {
    try {
      final db = await database;

      // ✅ Check if an entry with the same timestamp exists
      List<Map<String, dynamic>> existingData = await db.query(
        'glucose_readings',
        where: 'timestamp = ?',
        whereArgs: [data['timestamp']],
      );

      if (existingData.isEmpty) {
        // ✅ Insert only if no duplicate exists
        await db.insert(
          'glucose_readings',
          {
            'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
            'glucose_level': data['glucose_level'],
            'temperature': data['temperature'],
            'humidity': data['humidity'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print("✅ Glucose data saved: $data");
      } else {
        print("⚠️ Duplicate entry skipped: $data");
      }
    } catch (e) {
      print("❌ Error saving glucose data: $e");
    }
  }
}
