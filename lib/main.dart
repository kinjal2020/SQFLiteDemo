import 'package:flutter/material.dart';
import 'package:sqflitedemo/databse_repository.dart';
import 'package:sqflitedemo/todo_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<ToDoModel> listData = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  getDataFromDB() async {
    var data = await DatabaseRepository.getItems();
    print(data);
    setState(() {
      listData = data;
      print(listData.length);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getDataFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: (listData.isEmpty)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(listData[index].title),
                        Text(listData[index].id.toString()),
                        IconButton(
                            onPressed: () async {
                              await DatabaseRepository.updateItem(
                                  listData[index].id!, 'Topic', 'description1');
                              getDataFromDB();
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () async {
                              await DatabaseRepository.deleteItem(
                                listData[index].id!,
                              );
                              getDataFromDB();
                            },
                            icon: Icon(Icons.delete))
                      ],
                    )),
                  );
                }),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await DatabaseRepository.createItem('title2', 'description1');
              getDataFromDB();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () async {
              var data = await DatabaseRepository.getItemById(2);
              setState(() {
                listData = data;
              });
              // getDataFromDB();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.search),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
