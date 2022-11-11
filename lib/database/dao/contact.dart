import 'package:bytebank2/database/app.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:sqflite/sqlite_api.dart';

class ContactDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = {};
    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  List<Contact> _toList(List<Map<String, dynamic>> results) {
    final List<Contact> contacts = [];
    for (Map<String, dynamic> row in results) {
      final Contact contact =
          Contact(row[_id], row[_name], row[_accountNumber]);
      contacts.add(contact);
    }
    return contacts;
  }

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    return db.insert('contacts', _toMap(contact));
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> results = await db.query('contacts');
    return _toList(results);
  }

  Future<int> update(Contact contact) async {
    final db = await getDatabase();
    return await db.update(
      _tableName,
      _toMap(contact),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await getDatabase();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
