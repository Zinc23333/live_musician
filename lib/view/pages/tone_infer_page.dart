import 'package:flutter/material.dart';
import 'package:live_musician/data/net_cache.dart';
import 'package:live_musician/data/types/separate_sound.dart';
import 'package:live_musician/view/widgets/future_choice.dart';
import 'package:live_musician/view/widgets/gap.dart';

class ToneInferPage extends StatefulWidget {
  const ToneInferPage({super.key});

  @override
  State<ToneInferPage> createState() => _ToneInferPageState();
}

class _ToneInferPageState extends State<ToneInferPage> {
  String? voice;
  SeparateSound? separateSound;

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
        Text("请选择一首分离的乐曲", style: TextTheme.of(context).titleMedium),
        Gap(),
        FutureChoice(
          future: NetCache.fetchSeparateFiles(),
          showNameFunc: (e) => e.name,
          selected: separateSound,
          onSelected: (e) {
            setState(() {
              separateSound = e;
            });
          },
        ),
        Gap(),
        ElevatedButton(onPressed: () {}, child: Text("开始推理")),
      ],
    );
  }
}
