import 'package:bytebank2/database/dao/avatar.dart';
import 'package:bytebank2/database/dao/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(
    path,
    onOpen: (db) {
      db.execute(ContactDao.tableSql);
      db.execute(AvatarDao.tableSql);
    },
    onCreate: ((db, version) {
      db.execute(ContactDao.tableSql);
      db.execute(AvatarDao.tableSql);
    }),
    version: 2,
    onDowngrade: onDatabaseDowngradeDelete,
  );
}
