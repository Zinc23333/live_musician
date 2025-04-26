import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerDialog extends StatefulWidget {
  const VideoPlayerDialog(this.videoUrl, {super.key});
  final String videoUrl;

  void show(BuildContext context) =>
      showDialog(context: context, builder: (context) => this);

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  VideoPlayerController? controller; // 视频播放控制器
  Timer? _timer; // 定时器用于更新 UI

  @override
  void initState() {
    super.initState();
    _initVideo(); // 初始化视频
  }

  /// 异步初始化视频
  Future<void> _initVideo() async {
    try {
      controller = VideoPlayerController.network(widget.videoUrl);
      await controller!.initialize();
      if (mounted) {
        setState(() {});
      }
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (mounted) {
          setState(() {});
        }
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // 取消定时器
    controller?.dispose(); // 释放播放器资源
    super.dispose();
  }

  /// 格式化时间为 mm:ss
  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller!.value.hasError) {
      return Center(child: Text('错误: ${controller!.value.errorDescription}'));
    }

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: VideoPlayer(controller!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  setState(() {
                    if (controller!.value.isPlaying) {
                      controller!.pause();
                    } else {
                      controller!.play();
                    }
                  });
                },
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: controller!.value.duration.inMilliseconds.toDouble(),
                  value: controller!.value.position.inMilliseconds
                      .toDouble()
                      .clamp(
                        0,
                        controller!.value.duration.inMilliseconds.toDouble(),
                      ),
                  onChanged: (value) {
                    controller!.seekTo(Duration(milliseconds: value.toInt()));
                  },
                ),
              ),
              Text(
                '${formatDuration(controller!.value.position)} / ${formatDuration(controller!.value.duration)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
