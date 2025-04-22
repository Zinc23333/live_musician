class SeparateSound {
  const SeparateSound(this.name, this.files);

  final String name;
  final List<String> files;

  factory SeparateSound.fromJson(MapEntry<String, dynamic> json) {
    // return SeparateSound(
    //   json['name'] as String,
    //   (json['files'] as List<dynamic>).cast<String>(),
    // );
    return SeparateSound(
      json.key,
      (json.value as List<dynamic>).cast<String>(),
    );
  }
}
