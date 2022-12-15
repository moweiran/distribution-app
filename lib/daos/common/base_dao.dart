import 'sqlite_helper.dart';

class BaseService{
  final db  = SqliteHelper.instance.db;
}