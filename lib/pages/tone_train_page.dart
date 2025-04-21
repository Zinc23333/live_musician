import 'package:flutter/material.dart';
import 'package:live_musician/widgets/drop_file.dart';
import 'package:live_musician/widgets/gap.dart';

class ToneTrainPage extends StatefulWidget {
  const ToneTrainPage({super.key});

  @override
  State<ToneTrainPage> createState() => _ToneTrainPageState();
}

class _ToneTrainPageState extends State<ToneTrainPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: '请输入任务名称',
          ),
        ),

        Gap(),
        Text("请上传包含音频文件的压缩包", style: TextTheme.of(context).titleMedium),

        Gap(),
        DropFile(allowExtension: ["zip"]),
        Gap(),
        ElevatedButton(onPressed: () {}, child: Text("开始训练")),
      ],
      // ),
      // ],
    );
  }
}
