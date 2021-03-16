import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'model/customer_saved_offer.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(CustomerSavedOffer.CREATE_TABLE_QUERY);
    print("Table is created");
  }

  Future<List<CustomerSavedOffer>> getAll() async {
    var dbClient = await db;
    List<Map<String, dynamic>> map = await dbClient.query(CustomerSavedOffer.TABLE_NAME);
    List<CustomerSavedOffer> offers = new List();
    if(map != null){
      offers =  map.map((item) => CustomerSavedOffer.fromDB(item)).toList();
    }

    return offers;
  }

  //insertion
  Future<int> save(CustomerSavedOffer customerSavedOffer) async {
    var dbClient = await db;
    int res = await dbClient.insert(CustomerSavedOffer.TABLE_NAME, customerSavedOffer.toMap());
    return res;
  }

  //updation
  Future<int> update(CustomerSavedOffer customerSavedOffer) async {
    var dbClient = await db;
    int res = await dbClient.update(CustomerSavedOffer.TABLE_NAME, customerSavedOffer.toMap(), where: "${CustomerSavedOffer.COLUMN_ID} = ?", whereArgs: [customerSavedOffer.id]);
    return res;
  }

  //deletion
  Future<int> delete(CustomerSavedOffer customerSavedOffer) async {
    var dbClient = await db;
    int res = await dbClient.delete(CustomerSavedOffer.TABLE_NAME, where: "${CustomerSavedOffer.COLUMN_ID} = ?", whereArgs: [customerSavedOffer.id]);
    return res;
  }
}