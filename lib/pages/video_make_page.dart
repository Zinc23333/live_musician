import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:live_musician/data/net_cache.dart';
import 'package:live_musician/widgets/drop_file.dart';
import 'package:live_musician/widgets/future_choice.dart';
import 'package:live_musician/widgets/gap.dart';

class VideoMakePage extends StatefulWidget {
  const VideoMakePage({super.key});

  @override
  State<VideoMakePage> createState() => _VideoMakePageState();
}

class _VideoMakePageState extends State<VideoMakePage> {
  String? voice;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("请选择音色", style: TextTheme.of(context).titleMedium),
        Gap(),
        FutureChoice(
          future: NetCache.fetchVoice(),
          showNameFunc: (e) => e.split(".").first,
          selected: voice,
          onSelected: (e) {
            setState(() {
              voice = e;
            });
          },
        ),
        Gap(),
        Text("请上传一段歌曲", style: TextTheme.of(context).titleMedium),
        Gap(),
        DropFile(allowExtension: ["mp3", ".wav"], fileType: FileType.audio),
      ],
    );
  }
}
