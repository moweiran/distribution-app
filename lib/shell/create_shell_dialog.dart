import 'dart:io';

import 'package:distribution_app/daos/distributions_dao.dart';
import 'package:distribution_app/models/distributions_entity.dart';
import 'package:flutter/material.dart';

import '../models/enums/distribution_platform.dart';

class CreateShellDialog extends StatefulWidget {
  const CreateShellDialog({super.key});

  @override
  State<CreateShellDialog> createState() => _CreateShellDialogState();
}

class _CreateShellDialogState extends State<CreateShellDialog> {
  final _cmdText = TextEditingController();
  final _name = TextEditingController();
  DistributionPlatform _platform = DistributionPlatform.android;

  @override
  void dispose() {
    _cmdText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: 500,
          width: 500,
          color: Colors.white,
          child: Column(
            children: [
              const Center(
                  child: Text(
                '创建批处理',
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _name,
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
                              _platform = value ?? DistributionPlatform.android;
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
                        controller: _cmdText,
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
    );
  }

  void _confirm() async {
    final entity = DistributionEntity(
      id: 0,
      name: _name.text.trim(),
      platform: _platform.index,
      cmdText: _cmdText.text.trim(),
    );
    DistributionDao().insert(entity);
  }
}

// class PlatformRadio extends StatelessWidget {
//   final DistributionPlatform value;
//   final ValueChanged<DistributionPlatform?> onChanged;
//   final DistributionPlatform groupValue;
//   const PlatformRadio({
//     Key? key,
//     required this.value,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Radio<DistributionPlatform>(
//       value: value,
//       groupValue: DistributionPlatform.android,
//       onChanged: onChanged,
//     );
//   }
// }
