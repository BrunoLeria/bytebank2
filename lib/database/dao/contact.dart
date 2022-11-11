import 'package:bytebank2/database/app.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqlite_api.dart';

class ContactDao {
  static const String dropTableSql = 'DROP TABLE IF EXISTS $_tableName;';
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_email TEXT, '
      '$_balance REAL, '
      '$_accountNumber INTEGER)';
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _email = 'email';
  static const String _balance = 'balance';
  static const String _accountNumber = 'account_number';

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = {};
    contactMap[_name] = contact.name;
    contactMap[_email] = contact.email;
    contactMap[_accountNumber] = contact.accountNumber;
    contactMap[_balance] = contact.balance;
    return contactMap;
  }

  List<Contact> _toList(List<Map<String, dynamic>> results) {
    final List<Contact> contacts = [];
    for (Map<String, dynamic> row in results) {
      final Contact contact = Contact(row[_id], row[_name], row[_email],
          row[_accountNumber], row[_balance]);
      contacts.add(contact);
    }
    return contacts;
  }

  Future<int> save(Contact contact, password, BuildContext context) async {
    final Database db = await getDatabase();
    AuthService.to.signUp(contact.email!, password, context);
    return db.insert('contacts', _toMap(contact));
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> results = await db.query('contacts');
    return _toList(results);
  }

  Future<Contact> findByEmail(String email) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> results =
        await db.query('contacts', where: 'email = ?', whereArgs: [email]);
    return _toList(results).first;
  }

  Future<List<int>> findAllAccountNumbers() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> results = await db.query('contacts');
    final List<int> accountNumbers = [];
    for (Map<String, dynamic> row in results) {
      accountNumbers.add(row[_accountNumber]);
    }
    return accountNumbers;
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

  Future<double> getBalance(String email) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> results =
        await db.query('contacts', where: 'email = ?', whereArgs: [email]);
    return results[0][_balance];
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
