import 'package:flutter/material.dart';
import 'package:live_musician/data/exts/scaffold_messenger_state_ex.dart';
import 'package:live_musician/data/net/net.dart';
import 'package:live_musician/data/types/separate_sound.dart';
import 'package:live_musician/view/widgets/music_player_dialog.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';

class SoundSplitHistoryDialog extends StatelessWidget {
  const SoundSplitHistoryDialog(this.data, {super.key});

  final List<SeparateSound> data;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("音频分离历史记录"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              data
                  .map(
                    (e) => ListTile(
                      title: _buildTitle(e, context),
                      subtitle: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              e.files
                                  .map(
                                    (fn) => _buildFileName(context, e.name, fn),
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

  Widget _buildTitle(SeparateSound e, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(e.name, style: TextTheme.of(context).titleMedium),
        IconButton(
          onPressed: () {
            final nav = Navigator.of(context);
            final sms = ScaffoldMessenger.of(context);
            WaitingDialog(Net.exchangeSeparateFiles(e.name)).show(context).then(
              (v) {
                if (v == true) {
                  nav.pop();
                  sms.showSuccess("交换成功");
                } else if (v == false) {
                  sms.showError("交换失败");
                }
              },
            );
          },
          icon: Icon(Icons.compare_arrows_rounded),
          color: Colors.grey,
          tooltip: "交换乐器和人声",
        ),
      ],
    );
  }

  Widget _buildFileName(BuildContext context, String dname, String fname) {
    final isIns = fname.startsWith("instrument");
    final isVocal = fname.startsWith("vocal");

    return TextButton.icon(
      onPressed: () {
        WaitingDialog(Net.getUrlSeparate(dname, fname)).show(context).then((v) {
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
