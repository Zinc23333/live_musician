import 'package:flutter/material.dart';
import 'package:live_musician/data/exts/scaffold_messenger_state_ex.dart';
import 'package:live_musician/data/net/net.dart';
import 'package:live_musician/data/net/net_cache.dart';
import 'package:live_musician/data/types/separate_sound.dart';
import 'package:live_musician/view/widgets/future_choice.dart';
import 'package:live_musician/view/widgets/gap.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';

class VoiceInferPage extends StatefulWidget {
  const VoiceInferPage({super.key});

  @override
  State<VoiceInferPage> createState() => _VoiceInferPageState();
}

class _VoiceInferPageState extends State<VoiceInferPage> {
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
            voice = e;
            setState(() {});
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
            separateSound = e;
            setState(() {});
          },
        ),
        Gap(),
        ElevatedButton(
          onPressed: () {
            final sms = ScaffoldMessenger.of(context);

            if (voice == null) {
              sms.show("请选择音色文件");
              return;
            }
            if (separateSound == null) {
              sms.show("请选择乐曲文件");
              return;
            }

            WaitingDialog(
              Net.voiceInfer(voice!, separateSound!.name),
            ).show(context).then((v) {
              if (v == true) {
                sms.show("任务提交成功");
              } else {
                sms.show("任务提交失败");
              }
            });
          },
          child: Text("开始推理"),
        ),
      ],
    );
  }
}
