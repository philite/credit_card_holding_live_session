import 'package:credit_card_holding2/card_type.dart';
import 'package:credit_card_holding2/credit_card.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDatabase {
  static final _instance = SqlDatabase._();
  static late Database _database;

  static const String _tableCreditCard = "creditCardTable";
  static const String columnId = "id";
  static const String columnCardNumber = "cardNumber";
  static const String columnExpireDate = "expireDate";
  static const String columnCardType = "type";

  static const String _createTable = "CREATE TABLE $_tableCreditCard("
      "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      "$columnCardNumber TEXT,"
      "$columnExpireDate DATETIME,"
      "$columnCardType TEXT)";

  SqlDatabase._();

  static Future<SqlDatabase> createInstance() async {
    await initDatabase().then((db) => _database = db);
    return _instance;
  }

  static Future<Database> initDatabase() async {
          // ไม่ await
    // openDatabase(""); // getDatabasesPath() = ""
    // join("", "credit_database.db") = "credit_database.db"

          // await
    // openDatabase("C:\Downloads\"); // await getDatabasesPath() = "C:\Downloads\"
    // join("C:\Downloads\", "credit_database.db") = "C:\Downloads\credit_database.db"
    return openDatabase(join(await getDatabasesPath(), "credit_database.db"),
        version: 1,
        onCreate: _onCreate // (db, version) async => await db.execute(_createTable)
        );
  }

  static void _onCreate(Database db, int version) async {
    await db.execute(_createTable);
  }

  Future addCard(CreditCard card) async {
    _database.insert(_tableCreditCard, card.toMap());
  }

  Future deleteCard(int id) {
    // WHERE id = 0
    return _database.delete(_tableCreditCard, where: "$columnId = $id");
  }

  Future<List<Map<String, Object?>>> getCardById(int id) {
    return _database.query(_tableCreditCard, where: "$columnId = $id");
  }

  Future updateCard(CreditCard card) {
    return _database.update(
        _tableCreditCard,
        card.toMap(),
        where: "$columnId = ${card.id}");
  }

  Future<List<CreditCard>> getAllCards() async {
    var logger = Logger();
    List<CreditCard> list = List<CreditCard>.empty(growable: true);
    await _database.query(_tableCreditCard).then(
            (cards) {
              for (var card in cards) {
                list.add(CreditCard.fromMap(card));
              }
            }
    );

    return list;
  }

  Future<List<CreditCard>> getCardsByType(CardType type) {
    // Same mechanic as getAllCards();
    List<CreditCard> list = List<CreditCard>.empty(growable: true);
    // "SELECT * FROM creditCardTable WHERE type = 'masterCard'"
    return _database.query(_tableCreditCard, where: "$columnCardType = '${type.name}'")
        .then((cards) => {
          for (var value in cards) {
            list.add(CreditCard.fromMap(value))
          }
    }).then((value) => list);
  }
}
