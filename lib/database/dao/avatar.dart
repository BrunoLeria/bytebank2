import 'package:bytebank2/database/app.dart';
import 'package:bytebank2/models/avatar.dart';
import 'package:sqflite/sqlite_api.dart';

class AvatarDao {
  static const String dropTableSql = 'DROP TABLE IF EXISTS $_tableName;';
  static const String tableSql = 'CREATE TABLE IF NOT EXISTS $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_imagem TEXT,'
      '$_email TEXT)';

  static const String _tableName = 'avatars';
  static const String _id = 'id';
  static const String _imagem = 'imagem';
  static const String _email = 'email';

  Map<String, dynamic> _toMap(Avatar avatar) {
    final Map<String, dynamic> avatarMap = {};
    avatarMap[_imagem] = avatar.imagem;
    avatarMap[_email] = avatar.email;
    return avatarMap;
  }

  List<Avatar> _toList(List<Map<String, dynamic>> results) {
    final List<Avatar> avatars = [];
    for (Map<String, dynamic> row in results) {
      final Avatar avatar = Avatar(row[_id], row[_imagem], row[_email]);
      avatars.add(avatar);
    }
    return avatars;
  }

  Future<int> save(Avatar avatar) async {
    final Database db = await getDatabase();
    return db.insert('avatars', _toMap(avatar));
  }

  Future<List<Avatar>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> results = await db.query('avatars');
    return _toList(results);
  }

  Future<Avatar> findByEmail(String email) async {
    final Database db = await getDatabase();
    Avatar avatar = Avatar(0, null, null);
    try {
      final List<Map<String, dynamic>> results =
          await db.query('avatars', where: 'email = ?', whereArgs: [email]);
      avatar = Avatar(results[0][_id], results[0][_imagem], results[0][_email]);
    } catch (e) {
      print("avatar não encontrado");
    }
    return avatar;
  }

  Future<int> update(Avatar avatar) async {
    final db = await getDatabase();
    return await db.update(
      _tableName,
      _toMap(avatar),
      where: 'id = ?',
      whereArgs: [avatar.id],
    );
  }
}
