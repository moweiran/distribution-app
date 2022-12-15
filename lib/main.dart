import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:sqlite3/sqlite3.dart';

import 'daos/distributions_dao.dart';
import 'shell/create_shell_dialog.dart';
import 'daos/common/sqlite_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

  List<ProcessResult> _processResults = [];
  @override
  void initState() {
    SqliteHelper.instance.init();
    DistributionDao().createTable();
    super.initState();
  }

  void testSqlite3() async {
    // // You can run select statements with PreparedStatement.select, or directly
    // // on the database:
    // final ResultSet resultSet =
    //     db.select('SELECT * FROM artists WHERE name LIKE ?', ['The %']);

    // // You can iterate on the result set in multiple ways to retrieve Row objects
    // // one by one.
    // for (final row in resultSet) {
    //   print('Artist[id: ${row['id']}, name: ${row['name']}]');
    // }

    // // Register a custom function we can invoke from sql:
    // db.createFunction(
    //   functionName: 'dart_version',
    //   argumentCount: const AllowedArgumentCount(0),
    //   function: (args) => Platform.version,
    // );
    // print(db.select('SELECT dart_version()'));
  }

  void _incrementCounter() async {
    // print(db.select('SELECT dart_version()'));
    // var shell = Shell();
    // final results = await shell.run('''
    //   echo "hello world"
    // ''');
    // _processResults.addAll(results);
    // setState(() {});
    showDialog(
      context: context,
      builder: (_) => const CreateShellDialog(),
    );
  }

  @override
  void dispose() {
    SqliteHelper.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: itemBuilder,
              itemCount: _processResults.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Text(_processResults[index].stdout);
  }
}
