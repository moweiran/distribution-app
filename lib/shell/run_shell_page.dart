import 'dart:io';

import 'package:distribution_app/models/distributions_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

import '../daos/distributions_dao.dart';

class RunShellPage extends StatefulWidget {
  final int id;
  const RunShellPage({super.key, required this.id});

  @override
  State<RunShellPage> createState() => _RunShellPageState();
}

class _RunShellPageState extends State<RunShellPage> {
  DistributionEntity? _entity;
  final List<String> _processResults = [];
  final _dao = DistributionDao();
  final ValueNotifier<bool> _running = ValueNotifier(false);

  @override
  void initState() {
    _single();
    super.initState();
  }

  void _single() async {
    try {
      _entity = await _dao.single(widget.id);
      _runCmdText();
      setState(() {});
    } catch (e, s) {
      print(s);
    }
  }

  void _runCmdText() async {
    _running.value = true;
    // final results = await compute(_executeCmd, _entity!);
    final results = await _executeCmd(_entity!);
    _processResults.addAll(results);
    _running.value = false;
  }

  String get _title => _entity == null ? "loading" : _entity!.name;

  @override
  void dispose() {
    _entity?.kill?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Column(
        children: <Widget>[
          Text(_entity?.cmdText ?? ""),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _running,
              builder: (_, running, w) {
                if (running) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: itemBuilder,
                  itemCount: _processResults.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Text(_processResults[index]);
  }
}

Future<List<String>> _executeCmd(DistributionEntity entity) async {
  final shell = Shell(
    workingDirectory: entity.workingDirectory,
    runInShell: true,
  );
  entity.kill = () {
    shell.kill(ProcessSignal.sigkill);
  };
  final results = await shell.run(
    '''
    ${entity.cmdText}
   ''',
    onProcess: (process) {
      // process.outLines.listen((event) {
      //   _processResults.add(event);
      // });
      // process.stdout.
      // process.outLines
    },
  );
  return results.map((e) => e.outText).toList();
}
