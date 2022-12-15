import 'package:sqlite3/sqlite3.dart';

import '../models/distributions_entity.dart';
import 'common/base_dao.dart';

class DistributionDao extends BaseService {
  void createTable() async {
    try {
      // db.execute('DROP TABLE distributions;');
      db.execute('''
      CREATE TABLE IF NOT EXISTS distributions (
        id INTEGER NOT NULL PRIMARY KEY,
        name TEXT NOT NULL,
        platform INTEGER NOT NULL,
        env TEXT NOT NULL,
        workingDirectory TEXT NOT NULL,
        cmdText TEXT NOT NULL
      );
    ''');
    } catch (e, s) {
      print(s);
    }
  }

  void insert(DistributionEntity entity) async {
    late PreparedStatement stmt;
    try {
      // Prepare a statement to run it multiple times:
      stmt = db.prepare(
        '''
          INSERT INTO distributions (name,platform,env,workingDirectory,cmdText) VALUES (?,?,?,?,?)
        ''',
      );
      stmt.execute([
        entity.name,
        entity.platform,
        entity.env,
        entity.workingDirectory,
        entity.cmdText,
      ]);
    } catch (e, s) {
      print(s);
    } finally {
      // Dispose a statement when you don't need it anymore to clean up resources.
      stmt.dispose();
    }
  }

  void update(DistributionEntity entity) async {
    late PreparedStatement stmt;
    try {
      // Prepare a statement to run it multiple times:
      stmt = db.prepare(
        '''
          UPDATE distributions set 
          name = ?,
          platform = ?,
          env = ?,
          workingDirectory = ?,
          cmdText = ? 
          where id = ?
        ''',
      );
      stmt.execute([
        entity.name,
        entity.platform,
        entity.env,
        entity.workingDirectory,
        entity.cmdText,
        entity.id,
      ]);
    } catch (e, s) {
      print(s);
    } finally {
      // Dispose a statement when you don't need it anymore to clean up resources.
      stmt.dispose();
    }
  }

  Future<DistributionEntity?> single(int id) async {
    try {
      final ResultSet resultSet =
          db.select('''select * from distributions where id = ?''', [id]);
      final entity = _convertEntity(resultSet[0]);
      return entity;
    } catch (e, s) {
      print(s);
    }
  }

  Future<List<DistributionEntity>> query(String keyword) async {
    List<DistributionEntity> entities = [];
    try {
      final ResultSet resultSet = db.select('''
        SELECT * FROM distributions
        ''');
      // db.select('SELECT * FROM distributions WHERE name LIKE ?', ['The %']);
      for (final row in resultSet) {
        final entity = _convertEntity(row);
        entities.add(entity);
      }
    } catch (e, s) {
      print(s);
    }
    return entities;
  }

  DistributionEntity _convertEntity(Row row) {
    final entity = DistributionEntity(
      id: row['id'],
      name: row['name'],
      platform: row['platform'],
      env: row['env'],
      workingDirectory: row['workingDirectory'],
      cmdText: row['cmdText'],
    );
    return entity;
  }
}
