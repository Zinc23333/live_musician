import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Video Player Demo')),
//         body: Center(
//           child: ElevatedButton(
//             child: Text('播放视频'),
//             onPressed: () async {
//               // 替换为你的视频字节数据
//               final videoData = await _loadSampleVideo();
//               showDialog(
//                 context: context,
//                 builder: (context) => VideoPlayerDialog(videoBytes: videoData),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Future<Uint8List> _loadSampleVideo() async {
//     // 这里应该加载你的视频数据，示例使用空数据
//     return Uint8List(0);
//   }
// }

class VideoPlayerDialog extends StatefulWidget {
  const VideoPlayerDialog(this.videoBytes, {super.key});
  final Uint8List videoBytes;

  void show(BuildContext context) =>
      showDialog(context: context, builder: (context) => this);

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;
  String? _tempFilePath;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // 创建临时文件
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'temp_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final tempFile = File(path.join(tempDir.path, fileName));
      await tempFile.writeAsBytes(widget.videoBytes);
      _tempFilePath = tempFile.path;

      // 初始化视频控制器
      _controller = VideoPlayerController.file(tempFile)..addListener(() {
        if (mounted) setState(() {});
      });

      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        if (mounted) setState(() {});
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    // 删除临时文件
    if (_tempFilePath != null) {
      try {
        final file = File(_tempFilePath!);
        if (file.existsSync()) file.deleteSync();
      } catch (e) {
        print('Error deleting temp file: $e');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_controller.value.isInitialized) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  }
                  return Text('视频初始化失败');
                } else if (snapshot.hasError) {
                  return Text('加载视频出错');
                }
                return Container(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
            SizedBox(height: 20),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    final duration = _controller.value.duration;
    final position = _controller.value.position;

    return Column(
      children: [
        Slider(
          value: position.inMilliseconds.toDouble(),
          min: 0,
          max: duration.inMilliseconds.toDouble(),
          onChanged: (value) {
            _controller.seekTo(Duration(milliseconds: value.toInt()));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
                setState(() {});
              },
            ),
            Text(
              '${_formatDuration(position)} / ${_formatDuration(duration)}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    return [
      duration.inMinutes,
      duration.inSeconds,
    ].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
  }
}
