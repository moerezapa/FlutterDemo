// have all the functionality to interact with database
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;


class DBHelper {
  // column name
  static const placeDBTable = 'user_places';
  static const placeID = 'id';
  static const placeTitle = 'title';
  static const placeImage = 'image';

  static Future<sqlite.Database> getDatabase() async {
    final dbPath = await sqlite.getDatabasesPath();
    return sqlite.openDatabase(
      path.join(dbPath, 'places.db'),
      // create db if doesnt exist (?)
      onCreate: (db, version) {
        // run sql query in our database
        return db.execute('CREATE TABLE $placeDBTable($placeID TEXT PRIMARY KEY, $placeTitle TEXT, $placeImage TEXT)');
      },
      version: 1  
    );
  }

  // insert to db
  static Future<void> insert(String tableName, Map<String, Object> data) async {
    final db = await DBHelper.getDatabase();
    db.insert(
      tableName, 
      data, 
      // sqlite.ConflictAlgorithm.replace will replace data if there is duplicate data
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace
    );
  }

  // fetch data
  static Future<List<Map<String, dynamic>>> getData(String tableName) async {
    final db = await DBHelper.getDatabase();
    // return value of this syntax is a list
    return db.query(tableName);
  }
}

