import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:live_musician/data/exts/scaffold_messenger_state_ex.dart';
import 'package:live_musician/data/net.dart';
import 'package:live_musician/data/net_cache.dart';
import 'package:live_musician/data/types/separate_model.dart';
import 'package:live_musician/view/widgets/drop_file.dart';
import 'package:live_musician/view/widgets/future_choice.dart';
import 'package:live_musician/view/widgets/gap.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';

class SoundSplitPage extends StatefulWidget {
  const SoundSplitPage({super.key});

  @override
  State<SoundSplitPage> createState() => _SoundSplitPageState();
}

class _SoundSplitPageState extends State<SoundSplitPage> {
  SeparateModel? selectedModel;
  TextEditingController taskNameController = TextEditingController();
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
              style: TextStyle(color: Colors.white.withAlpha(180)),
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white.withAlpha(180),
                    size: 20,
                  ),
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
        DropFile(
          key: ValueKey("drop-file-1"),
          allowExtension: ["wav", "mp3", "flac", "aac", "ogg", "m4a"],
          fileType: FileType.audio,
          onFile: (d, f) {
            data = d;
            if (f != null) {
              taskNameController.text = f;
            }
          },
        ),
        Gap(),
        ElevatedButton(
          onPressed: () {
            final sms = ScaffoldMessenger.of(context);
            final tn = taskNameController.text.trim();
            if (tn.isEmpty) {
              sms.show("请输入任务名称");
              return;
            }
            if (selectedModel == null) {
              sms.show("请选择分离模型");
              return;
            }
            if (data == null) {
              sms.show("请上传音频文件");
              return;
            }

            WaitingDialog(
              Net.seperate(tn, selectedModel!, data!),
            ).show(context).then((v) {
              if (v == true) {
                sms.show("分离成功");
              } else {
                sms.show("分离失败");
              }
            });
          },
          child: Text("开始分离"),
        ),
      ],
      // ),
      // ],
    );
  }
}
