class VideoFile {
  VideoFile({
    required this.name,
    required this.seed,
    required this.containOriginalFile,
    required this.containInferFile,
    required this.containInferFileWithMusic,
  });

  final String name;
  final String seed;
  final bool containOriginalFile;
  final bool containInferFile;
  final bool containInferFileWithMusic;

  factory VideoFile.fromJson(Map<String, dynamic> json) {
    return VideoFile(
      name: json['taskName'],
      seed: json['seed'],
      containOriginalFile: json['containOriginalFile'],
      containInferFile: json['containInferFile'],
      containInferFileWithMusic: json['containInferFileWithMusic'],
    );
  }

  List<(String, String)> get video => [
    if (containOriginalFile) ("原视频", "1.mp4"),
    if (containInferFile) ("变声视频", "2.mp4"),
    if (containInferFileWithMusic) ("变声视频+音乐", "3.mp4"),
  ];
}
