
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'farah.db'); //databasepath/farah.db
    //add path with db name ,link name with path to be ready
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 16, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    print("_onUpgrade =====================");
    // await db.execute("ALTER TABLE notes ADD COLUMN color TEXT");
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch(); //add more than table in one time
    //create tables
    batch.execute('''
  CREATE TABLE "notes"(
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "title" TEXT NOT NULL,
  "color" TEXT NOT NULL,
  "note" TEXT NOT NULL)
  ''');
    batch.execute('''
  CREATE TABLE "students"(
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "title" TEXT NOT NULL,
  "note" TEXT NOT NULL)
  ''');
    await batch.commit();

    print("Create db and table ==================");
  }

  // readData(String sql) async{ //select
  //   Database? mydb = await db;
  //   List<Map> response = await mydb!.rawQuery(sql);
  //   return response;
  // }
  //
  // insertData(String sql) async{
  //   Database? mydb = await db;
  //   int response = await mydb!.rawInsert(sql); //0 fail , 1 success
  //   return response;
  // }
  //
  // updateData(String sql) async{
  //   Database? mydb = await db;
  //   int response = await mydb!.rawUpdate(sql); //0 fail , 1 success
  //   return response;
  // }
  //
  // deleteData(String sql) async{
  //   Database? mydb = await db;
  //   int response = await mydb!.rawDelete(sql); //0 fail , 1 success
  //   return response;
  // }

  deleteDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'farah.db'); //databasepath/farah.db
    await deleteDatabase(path);
  }

  //more abbreviate =>
  read(String table) async {
    //select
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insert(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, values); //0 fail , 1 success
    return response;
  }

  update(String table, Map<String, Object?> values, String myWhere) async {
    Database? mydb = await db;
    int response =
        await mydb!.update(table, values, where: myWhere); //0 fail , 1 success
    return response;
  }

  delete(String table, String myWhere) async {
    Database? mydb = await db;
    int response =
        await mydb!.delete(table, where: myWhere); //0 fail , 1 success
    return response;
  }
}
