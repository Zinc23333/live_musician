import 'package:flutter/material.dart';
import 'package:live_musician/data/func/save_u8l_file.dart';
import 'package:live_musician/data/net/net.dart';
import 'package:live_musician/data/types/video_file.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_io/io.dart';

class VideoMakerHistoryDialog extends StatelessWidget {
  const VideoMakerHistoryDialog(this.file, {super.key});

  final List<VideoFile> file;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("音色推理历史记录"),
      content: SingleChildScrollView(
        child: Column(
          children: file.map((e) => _bhuildTile(e, context)).toList(),
        ),
      ),
    );
  }

  ListTile _bhuildTile(VideoFile e, BuildContext context) {
    return ListTile(
      title: Text(e.name),
      subtitle: Wrap(
        // children: [RawChip(label: Text("原视频"))],
        children:
            e.video
                .map(
                  (v) => RawChip(
                    label: Text(v.$1),
                    onPressed: () {
                      WaitingDialog(
                        Net.fetchFileVideoInfer(e.seed, v.$2),
                      ).show(context).then((v) async {
                        if (v != null) {
                          if (Platform.isLinux || Platform.isWindows) {
                            final r = await saveUint8listToFileTemp(v, ".mp4");
                            await OpenFile.open(r);
                          }
                        }
                        // if (v != null && context.mounted) {
                        // MusicPlayerDialog(v).show(context);

                        // }
                      });
                    },
                  ),
                )
                .toList(),
      ),
      // title: Text.rich(
      //   TextSpan(
      //     children: [
      //       TextSpan(text: e.name, style: TextStyle(color: Colors.amber)),
      //       const TextSpan(text: "  "),
      //       TextSpan(text: e.toneName, style: TextStyle(color: Colors.blue)),
      //     ],
      //   ),
      // ),
      // onTap: () {
      //   WaitingDialog(Net.fetchFileInfer(e)).show(context).then((v) {
      //     if (v != null && context.mounted) {
      //       MusicPlayerDialog(v).show(context);
      //     }
      //   });
      // },
    );
  }
}
