import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'daos/distributions_dao.dart';
import 'models/distributions_entity.dart';
import 'router/router.dart';
import 'shell/create_shell_dialog.dart';
import 'daos/common/sqlite_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
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
  List<DistributionEntity> _list = [];
  @override
  void initState() {
    SqliteHelper.instance.init();
    DistributionDao().createTable();
    _query();
    super.initState();
  }

  void _query() async {
    try {
      _list = await DistributionDao().query('');
      setState(() {});
    } catch (e, s) {
      //
    }
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

  void _incrementCounter({int? id}) async {
    final refresh = await showDialog(
      context: context,
      builder: (_) => CreateShellDialog(id: id),
    );
    if (refresh != null && refresh) {
      _query();
    }
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

      body: _buildTable(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder.all(
        color: Colors.grey,
      ),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(60),
        1: IntrinsicColumnWidth(flex: 1),
        2: FixedColumnWidth(100),
        3: FixedColumnWidth(100),
        4: IntrinsicColumnWidth(flex: 1),
        5: FixedColumnWidth(100),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        _buildTableHeader(),
        ..._list.map((item) => _buildRow(item)).toList()
      ],
    );
  }

  TableRow _buildRow(DistributionEntity entity) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              '${entity.id}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          child: Text(
            entity.name,
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Text(
            entity.platformText,
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Text(
            entity.env,
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Text(
            entity.workingDirectory,
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    context.goNamed('run', params: {'id': '${entity.id}'});
                  },
                  child: const Text('run'),
                ),
                InkWell(
                  onTap: () => _incrementCounter(id: entity.id),
                  child: const Text('edit'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      children: [
        TableCell(child: _buildHeaderCell("ID")),
        TableCell(child: _buildHeaderCell("Name")),
        TableCell(child: _buildHeaderCell("Platform")),
        TableCell(child: _buildHeaderCell("Env")),
        TableCell(child: _buildHeaderCell("WorkingDirectory")),
        TableCell(child: _buildHeaderCell("Operation")),
      ],
    );
  }

  Widget _buildHeaderCell(String headTitle) {
    return Container(
      color: Colors.grey[300],
      height: 40,
      alignment: Alignment.center,
      child: Text(
        headTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
