class SeparateModel {
  const SeparateModel({
    required this.model,
    required this.name,
    required this.description,
    required this.application,
  });

  final String model;
  final String name;
  final String description;
  final String application;

  factory SeparateModel.fromJson(Map<String, dynamic> json) {
    return SeparateModel(
      model: json['model'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      application: json['application'] as String,
    );
  }
}
