import 'package:flutter/material.dart';
import 'package:live_musician/data/net.dart';
import 'package:live_musician/view/widgets/music_player_dialog.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';

class SoundSplitHistoryDialog extends StatelessWidget {
  const SoundSplitHistoryDialog(this.data, {super.key});

  final Map<String, List<String>> data;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("音频分离历史记录"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              data.entries
                  .map(
                    (e) => ListTile(
                      title: Text(
                        e.key,
                        style: TextTheme.of(context).titleMedium,
                      ),
                      subtitle: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              e.value
                                  .map(
                                    (fn) => _buildFileName(context, e.key, fn),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildFileName(BuildContext context, String dname, String fname) {
    final isIns = fname.startsWith("instrument");
    final isVocal = fname.startsWith("vocal");

    return TextButton.icon(
      onPressed: () {
        WaitingDialog(Net.fetchFileSeparate(dname, fname)).show(context).then((
          v,
        ) {
          if (v != null && context.mounted) {
            MusicPlayerDialog(v).show(context);
          }
        });
      },
      label: Text(
        isIns
            ? "乐器"
            : isVocal
            ? "人声"
            : "其他",
        style: TextStyle(color: Colors.white),
      ),
      icon:
          isIns
              ? Icon(Icons.music_note_rounded, color: Colors.amber)
              : isVocal
              ? Icon(Icons.record_voice_over_rounded, color: Colors.blue)
              : Icon(Icons.file_present_rounded, color: Colors.grey),
    );
  }
}
