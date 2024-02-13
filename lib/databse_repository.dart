import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflitedemo/todo_model.dart';

class DatabaseRepository {

  ///Create Database

  static Future<Database> db() async {
    return openDatabase('dbtech.db', version: 1,
        onCreate: (database, int version) async {
      await _createDB(database, version);
    });
  }

  ///create table
  static Future _createDB(Database db, int version) async {
    await db.execute('''create table todoTable ( 
                       id integer primary key autoincrement, 
                       title text not null,
                       description text not null)   
                  ''');
  }

/// insert record
  static Future createItem(String title, String description) async {
    final db = await DatabaseRepository.db();

    final data = {'title': title, 'description': description};
    final id = await db.insert('todoTable', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    print(id);
    return id;
  }

/// get data from database
  static Future getItems() async {
    List<ToDoModel> todoList = [];
    final db = await DatabaseRepository.db();
    var data = await db.query('todoTable', orderBy: 'id');
    for (var e in data) {
      todoList.add(ToDoModel.fromJson(e));
    }
    return todoList;
  }

  /// get items by id
  static Future getItemById(int id) async {
    final db = await DatabaseRepository.db();
    List<ToDoModel> todoList = [];
    var data =
        await db.query('todoTable', where: "id=?", whereArgs: [id]);
    for (var e in data) {
      todoList.add(ToDoModel.fromJson(e));
    }
    return todoList;
  }

  /// update item
  static Future updateItem(int id, String title, String description) async {
    final db = await DatabaseRepository.db();
    final data = {'title': title, 'description': description};
    final result =
        await db.update('todoTable', data, where: "id=?", whereArgs: [id]);
    return result;
  }


  ///delete item
  static Future deleteItem(int id) async {
    final db = await DatabaseRepository.db();
    try {
      await db.delete('todoTable', where: "id=?", whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }
}
