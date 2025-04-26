import 'package:flutter/material.dart';
import 'package:live_musician/data/net/net.dart';
import 'package:live_musician/data/types/infer_file.dart';
import 'package:live_musician/view/widgets/music_player_dialog.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';

class VoiceInferHistoryDialog extends StatelessWidget {
  const VoiceInferHistoryDialog(this.file, {super.key});

  final List<InferFile> file;

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

  ListTile _bhuildTile(InferFile e, BuildContext context) {
    return ListTile(
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: e.musicName, style: TextStyle(color: Colors.amber)),
            const TextSpan(text: "  "),
            TextSpan(text: e.toneName, style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
      onTap: () {
        WaitingDialog(Net.getUrlFileInfer(e.seed)).show(context).then((v) {
          if (v != null && context.mounted) {
            MusicPlayerDialog(v).show(context);
          }
        });
      },
    );
  }
}
