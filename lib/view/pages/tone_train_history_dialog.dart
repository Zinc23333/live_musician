import 'package:flutter/material.dart';

class ToneTrainHistoryDialog extends StatelessWidget {
  const ToneTrainHistoryDialog(this.voice, {super.key});

  final List<String> voice;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("音色训练历史记录"),
      content: SingleChildScrollView(
        child: Column(
          children: voice.map((e) => ListTile(title: Text(e))).toList(),
        ),
      ),
    );
  }
}
