import 'package:flutter/material.dart';
import 'package:live_musician/data/net.dart';
import 'package:live_musician/view/pages/sound_split_history_dialog.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';

void historyDialogRoute(BuildContext context, int index) async {
  final fd = switch (index) {
    0 => Net.fetchSeparateFiles,
    _ => throw Exception('Invalid index'),
  };
  WaitingDialog(fd()).show(context).then((v) {
    if (v == null) return;
    final d = switch (index) {
      0 => SoundSplitHistoryDialog(v),
      _ => throw Exception('Invalid index'),
    };
    if (context.mounted) showDialog(context: context, builder: (_) => d);
  });
}
