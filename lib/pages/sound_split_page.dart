import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:live_musician/data/net_cache.dart';
import 'package:live_musician/data/types/separate_model.dart';
import 'package:live_musician/widgets/drop_file.dart';
import 'package:live_musician/widgets/future_choice.dart';
import 'package:live_musician/widgets/gap.dart';

class SoundSplitPage extends StatefulWidget {
  const SoundSplitPage({super.key});

  @override
  State<SoundSplitPage> createState() => _SoundSplitPageState();
}

class _SoundSplitPageState extends State<SoundSplitPage> {
  SeparateModel? selectedModel;

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
        Text("请选择分离模型", style: TextTheme.of(context).titleMedium),
        Gap(),
        FutureChoice(
          future: NetCache.fetchSeparateModel(),
          selected: selectedModel,
          showNameFunc: (e) => e.name,
          onSelected: (e) {
            setState(() {
              selectedModel = e;
            });
          },
        ),
        Gap(),
        if (selectedModel != null)
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                WidgetSpan(
                  child: Icon(Icons.info, color: Colors.grey, size: 20),
                ),
                TextSpan(text: " "),
                TextSpan(text: selectedModel!.description),
                TextSpan(text: selectedModel!.application),
              ],
            ),
          ),
        Gap(),
        Text("请上传包含音频文件", style: TextTheme.of(context).titleMedium),
        Gap(),
        DropFile(allowExtension: ["wav", "mp3"], fileType: FileType.audio),
        Gap(),
        ElevatedButton(onPressed: () {}, child: Text("开始分离")),
      ],
      // ),
      // ],
    );
  }
}
