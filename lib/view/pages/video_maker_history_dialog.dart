import 'package:flutter/material.dart';
import 'package:live_musician/data/func/save_u8l_file.dart';
import 'package:live_musician/data/net/net.dart';
import 'package:live_musician/data/types/video_file.dart';
import 'package:live_musician/view/widgets/gap.dart';
import 'package:live_musician/view/widgets/video_player_dialog.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: file.map((e) => _bhuildTile(e, context)).toList(),
        ),
      ),
    );
  }

  Widget _bhuildTile(VideoFile e, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(e.name, style: TextTheme.of(context).titleMedium),

        Gap(),
        Wrap(
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
                              final r = await saveUint8listToFileTemp(
                                v,
                                ".mp4",
                              );
                              await OpenFile.open(r);
                            } else {
                              if (context.mounted) {
                                VideoPlayerDialog(v).show(context);
                              }
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
      ],
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
