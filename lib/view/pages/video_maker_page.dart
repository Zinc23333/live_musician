import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:live_musician/data/exts/scaffold_messenger_state_ex.dart';
import 'package:live_musician/data/net/net.dart';
import 'package:live_musician/data/net/net_cache.dart';
import 'package:live_musician/data/types/infer_file.dart';
import 'package:live_musician/view/widgets/drop_file.dart';
import 'package:live_musician/view/widgets/future_choice.dart';
import 'package:live_musician/view/widgets/gap.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';

class VideoMakerPage extends StatefulWidget {
  const VideoMakerPage({super.key});

  @override
  State<VideoMakerPage> createState() => _VideoMakerPageState();
}

class _VideoMakerPageState extends State<VideoMakerPage> {
  final taskNameController = TextEditingController();
  InferFile? inferFile;

  Uint8List? data;
  String? fileType;

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
        Text("请选择音色", style: TextTheme.of(context).titleMedium),
        Gap(),
        FutureChoice(
          future: NetCache.fetchInferFiles(),
          showNameFunc: (e) => "${e.musicName} | ${e.toneName}",
          selected: inferFile,
          onSelected: (e) {
            inferFile = e;
            setState(() {});
          },
        ),
        Gap(),
        Text("请上传一段包含任务的视频", style: TextTheme.of(context).titleMedium),
        Gap(),
        DropFile(
          fileType: FileType.video,
          allowExtension: ["mp4", "avi", "mov", "mkv"],
          onFile: (data, fileName, fileType) {
            this.data = data;
            this.fileType = fileType;

            setState(() {});
          },
        ),
        Gap(),

        ElevatedButton(
          onPressed: () {
            final sms = ScaffoldMessenger.of(context);
            final t = taskNameController.text.trim();

            if (t.isEmpty) {
              sms.show("请输入任务名称");
              return;
            } else if (inferFile == null) {
              sms.show("请选择音色");
              return;
            } else if (data == null) {
              sms.show("请上传视频");
              return;
            }

            WaitingDialog(
              Net.videoMaker(t, inferFile!, data!, fileType!),
            ).show(context).then((v) {
              if (v == true) {
                sms.show("任务提交成功");
              } else {
                sms.show("任务提交失败");
              }
            });
          },
          child: Text("开始制作"),
        ),
      ],
    );
  }
}
