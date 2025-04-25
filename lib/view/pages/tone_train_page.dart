import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:live_musician/data/exts/scaffold_messenger_state_ex.dart';
import 'package:live_musician/data/net/net.dart';
import 'package:live_musician/view/widgets/drop_file.dart';
import 'package:live_musician/view/widgets/gap.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';

class ToneTrainPage extends StatefulWidget {
  const ToneTrainPage({super.key});

  @override
  State<ToneTrainPage> createState() => _ToneTrainPageState();
}

class _ToneTrainPageState extends State<ToneTrainPage> {
  final taskNameController = TextEditingController();
  Uint8List? data;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextField(
          controller: taskNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: '请输入任务名称',
          ),
        ),

        Gap(),
        Text("请上传包含音频文件的压缩包", style: TextTheme.of(context).titleMedium),

        Gap(),
        DropFile(
          key: ValueKey("drop-file-2"),
          allowExtension: ["zip"],
          onFile: (d, fileName) {
            data = d;
            if (fileName != null) {
              taskNameController.text = fileName;
            }
          },
        ),
        Gap(),
        ElevatedButton(
          onPressed: () {
            final tn = taskNameController.text.trim();
            if (tn.isEmpty) {
              ScaffoldMessenger.of(context).show("请输入任务名称");
              return;
            }
            if (data == null) {
              ScaffoldMessenger.of(context).show("请上传音频文件");
              return;
            }

            final sms = ScaffoldMessenger.of(context);
            WaitingDialog(Net.voiceTrain(tn, data!)).show(context).then((v) {
              if (v == true) {
                sms.show("训练成功");
              } else {
                sms.show("训练失败");
              }
            });
            ;
          },
          child: Text("开始训练"),
        ),
      ],
    );
  }
}
