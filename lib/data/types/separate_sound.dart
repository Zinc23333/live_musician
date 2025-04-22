class SeparateSound {
  const SeparateSound(this.name, this.files);

  final String name;
  final List<String> files;

  factory SeparateSound.fromJson(MapEntry<String, dynamic> json) {
    return SeparateSound(
      json.key,
      (json.value as List<dynamic>).cast<String>(),
    );
  }

  bool containVoice() => files.any((e) => e.startsWith("vocal"));
  bool containInstrument() => files.any((e) => e.startsWith("instrument"));
}
