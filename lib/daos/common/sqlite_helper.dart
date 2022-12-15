import 'package:sqlite3/sqlite3.dart';

class SqliteHelper {
  SqliteHelper._();
  static final instance = SqliteHelper._();
  factory SqliteHelper() => instance;

  late final Database db;

  void init() async {
    db = sqlite3.open('distribution_app');
  }

  void dispose() async {
    db.dispose();
  }
}
