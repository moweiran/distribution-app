import 'package:sqlite3/sqlite3.dart';

import '../models/distributions_entity.dart';
import 'common/base_dao.dart';

class DistributionDao extends BaseService {
  void createTable() async {
    db.execute('''
    CREATE TABLE IF NOT EXISTS distributions (
      id INTEGER NOT NULL PRIMARY KEY,
      name TEXT NOT NULL,
      platform INTEGER NOT NULL,
      cmdText TEXT NOT NULL
    );
  ''');
  }

  void insert(DistributionEntity entity) async {
    late final PreparedStatement stmt;
    try {
      // Prepare a statement to run it multiple times:
      stmt = db.prepare(
          'INSERT INTO distributions (name,platform,cmdText) VALUES (?)');
      stmt.execute([
        entity.name,
        entity.platform,
        entity.cmdText,
      ]);
    } catch (e, s) {
      //
    } finally {
      // Dispose a statement when you don't need it anymore to clean up resources.
      stmt.dispose();
    }
  }

  Future<List<DistributionEntity>> query(String keyword) async {
    List<DistributionEntity> entities = [];
    try {
      final ResultSet resultSet = db.select('SELECT * FROM distributions');
      // db.select('SELECT * FROM distributions WHERE name LIKE ?', ['The %']);
      for (final row in resultSet) {
        final entity = DistributionEntity(
          id: row['id'],
          name: row['name'],
          platform: row['platform'],
          cmdText: row['cmdText'],
        );
        entities.add(entity);
      }
    } catch (e, s) {
      //
    }
    return entities;
  }
}
