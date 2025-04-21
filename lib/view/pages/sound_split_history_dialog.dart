import 'package:flutter/material.dart';

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
                              e.value.map((e) => _buildFileName(e)).toList(),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildFileName(String name) {
    final isIns = name.startsWith("instrument");
    final isVocal = name.startsWith("vocal");

    return TextButton.icon(
      onPressed: () {},
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
