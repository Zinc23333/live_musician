class InferFile {
  const InferFile({
    required this.seed,
    required this.musicName,
    required this.toneName,
  });
  final String seed;
  final String musicName;
  final String toneName;

  factory InferFile.fromJson(Map<String, dynamic> json) {
    return InferFile(
      seed: json['seed'] as String,
      musicName: json['musicName'] as String,
      toneName: json['toneName'] as String,
    );
  }
}
