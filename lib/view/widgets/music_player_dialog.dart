import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:live_musician/view/widgets/gap.dart';

class MusicPlayerDialog extends StatefulWidget {
  const MusicPlayerDialog(this.audioUrl, {super.key});
  final String audioUrl;

  void show(BuildContext context) =>
      showDialog(context: context, builder: (context) => this);

  @override
  State<MusicPlayerDialog> createState() => _MusicPlayerDialogState();
}

class _MusicPlayerDialogState extends State<MusicPlayerDialog> {
  late AudioPlayer _player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isDragging = false;
  PlayerState _playerState = PlayerState.stopped;
  late final _source = UrlSource(widget.audioUrl);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
    _player.onPlayerStateChanged.listen(_handleStateChange);
  }

  Future<void> _initAudio() async {
    await _player.setSource(_source);

    _player.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });

    _player.onPositionChanged.listen((position) {
      if (!_isDragging && mounted) {
        setState(() => _position = position);
      }
    });

    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _position = _duration;
          _playerState = PlayerState.stopped;
        });
      }
    });
  }

  void _handleStateChange(PlayerState state) {
    if (mounted) {
      setState(() => _playerState = state);
    }
  }

  void _togglePlay() async {
    if (_playerState == PlayerState.playing) {
      await _player.pause();
    } else {
      if (_position >= _duration) {
        await _player.seek(Duration.zero);
      }
      if (_playerState == PlayerState.paused) {
        await _player.resume();
      } else {
        await _player.play(_source);
      }
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('正在播放'),
          Gap.expanded(),
          IconButton(
            icon: Icon(
              _playerState == PlayerState.playing
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 36,
            ),
            onPressed: _togglePlay,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            min: 0,
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.toDouble(),
            onChanged: (value) {
              setState(() {
                _isDragging = true;
                _position = Duration(seconds: value.toInt());
              });
            },
            onChangeEnd: (value) async {
              await _player.seek(Duration(seconds: value.toInt()));
              setState(() => _isDragging = false);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position)),
              Text(_formatDuration(_duration)),
            ],
          ),
        ],
      ),
    );
  }
}
