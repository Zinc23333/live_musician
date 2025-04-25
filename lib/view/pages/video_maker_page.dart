import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:live_musician/data/net_cache.dart';
import 'package:live_musician/data/types/infer_file.dart';
import 'package:live_musician/view/widgets/drop_file.dart';
import 'package:live_musician/view/widgets/future_choice.dart';
import 'package:live_musician/view/widgets/gap.dart';

class VideoMakerPage extends StatefulWidget {
  const VideoMakerPage({super.key});

  @override
  State<VideoMakerPage> createState() => _VideoMakerPageState();
}

class _VideoMakerPageState extends State<VideoMakerPage> {
  InferFile? inferFile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
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
          onFile: (data, fileName) {},
        ),
        Gap(),

        ElevatedButton(onPressed: () {}, child: Text("开始制作")),
      ],
    );
  }
}
