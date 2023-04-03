import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {
  Database? db;

  Future open() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'myPizzas.db');
    print(path);

    db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE pizzas (
            id integer primary key autoIncrement,
            image varchar(255) not null,
            name varchar(255) not null,
            toppings varchar(255) not null,
            price double not null
          )
        ''');
    });
  }
}
