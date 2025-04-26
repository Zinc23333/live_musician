import 'package:flutter/material.dart';
import 'package:live_musician/data/func/save_u8l_file.dart';
import 'package:live_musician/data/net/net.dart';
import 'package:live_musician/data/types/video_file.dart';
import 'package:live_musician/view/widgets/gap.dart';
import 'package:live_musician/view/widgets/video_player_page.dart';
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
          spacing: 8,
          runSpacing: 8,
          children:
              e.video
                  .map(
                    (v) => RawChip(
                      label: Text(v.$1),
                      onPressed: () => _onPressed(context, e, v.$2),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  void _onPressed(BuildContext context, VideoFile e, String v) {
    final nav = Navigator.of(context);
    if (Platform.isLinux) {
      WaitingDialog(Net.fetchFileVideoInfer(e.seed, v)).show(context).then((
        v,
      ) async {
        if (v != null) {
          final r = await saveUint8listToFileTemp(v, ".mp4");
          await OpenFile.open(r);
        }
      });
    } else {
      Net.getUrlFileVideoInfer(e.seed, v).then((value) {
        if (context.mounted) {
          nav.push(
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(videoUrl: value),
            ),
          );
        }
      });
    }
  }
}
