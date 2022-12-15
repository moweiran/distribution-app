import 'dart:io';

import 'package:distribution_app/daos/distributions_dao.dart';
import 'package:distribution_app/models/distributions_entity.dart';
import 'package:flutter/material.dart';

import '../models/enums/distribution_platform.dart';

class CreateShellDialog extends StatefulWidget {
  final int? id;
  const CreateShellDialog({super.key, this.id});

  @override
  State<CreateShellDialog> createState() => _CreateShellDialogState();
}

class _CreateShellDialogState extends State<CreateShellDialog> {
  final _dao = DistributionDao();
  int _id = 0;
  final _cmdTextCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _envCtrl = TextEditingController();
  final _workingDirectoryCtrl = TextEditingController();

  DistributionPlatform _platform = DistributionPlatform.android;
  DistributionEntity? _entity;
  @override
  void initState() {
    if (widget.id != null) {
      _single();
    }
    super.initState();
  }

  void _single() async {
    try {
      _entity = await _dao.single(widget.id!);
      if (_entity == null) return;
      _setValues();
    } catch (e, s) {
      print(s);
    }
  }

  void _setValues() {
    _id = _entity!.id;
    _cmdTextCtrl.text = _entity!.cmdText;
    _nameCtrl.text = _entity!.name;
    _envCtrl.text = _entity!.env;
    _platform = DistributionPlatform.values[_entity!.platform];
    _workingDirectoryCtrl.text = _entity!.workingDirectory;
    setState(() {});
  }

  @override
  void dispose() {
    _cmdTextCtrl.dispose();
    _nameCtrl.dispose();
    _envCtrl.dispose();
    _workingDirectoryCtrl.dispose();
    super.dispose();
  }

  String get _title => widget.id == null ? '新增' : '编辑';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            height: 500,
            width: 500,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    _title,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            hintText: '请输入名称',
                          ),
                        ),
                        ListTile(
                          title: const Text('Android'),
                          leading: Radio<DistributionPlatform>(
                            value: DistributionPlatform.android,
                            groupValue: _platform,
                            onChanged: (DistributionPlatform? value) {
                              setState(() {
                                _platform =
                                    value ?? DistributionPlatform.android;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          title: const Text('iOS'),
                          leading: Radio<DistributionPlatform>(
                            value: DistributionPlatform.ios,
                            groupValue: _platform,
                            onChanged: (DistributionPlatform? value) {
                              setState(() {
                                _platform = value ?? DistributionPlatform.ios;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        TextField(
                          controller: _envCtrl,
                          decoration: const InputDecoration(
                            hintText: '请输入环境',
                          ),
                        ),
                        TextField(
                          controller: _workingDirectoryCtrl,
                          decoration: const InputDecoration(
                            hintText: '请输入项目路径',
                          ),
                        ),
                        TextField(
                          controller: _cmdTextCtrl,
                          decoration: const InputDecoration(
                            hintText: '请输入脚本',
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _confirm,
                  child: Container(
                    color: Colors.blue,
                    width: double.infinity,
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text(
                      '确定',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirm() async {
    final entity = DistributionEntity(
      id: _id,
      name: _nameCtrl.text.trim(),
      platform: _platform.index,
      env: _envCtrl.text.trim(),
      workingDirectory: _workingDirectoryCtrl.text.trim(),
      cmdText: _cmdTextCtrl.text.trim(),
    );
    entity.id > 0 ? _dao.update(entity) : _dao.insert(entity);
    Navigator.pop(context, true);
  }
}
