import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:live_musician/data/types/separate_model.dart';

class Net {
  static const String baseUrl = "https://qaq.zinc233.top:48979/lm/";

  static Future<Duration?> ping() async {
    try {
      final start = DateTime.now();
      final response = await http.get(Uri.parse("${baseUrl}ping"));
      if (response.statusCode == 200) {
        final end = DateTime.now();
        return end.difference(start);
      }
      throw Exception("ping error");
    } catch (_) {
      return null;
    }
  }

  // 音色分离
  static Future<List<SeparateModel>> fetchSeparateModel() async {
    final response = await http.get(Uri.parse("${baseUrl}separate_model"));
    if (response.statusCode == 200) {
      final r = jsonDecode(response.body) as List;
      return r.map((e) => SeparateModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load separate model");
    }
  }

  // 音色推理
  static Future<List<String>> fetchVoice() async {
    final response = await http.get(Uri.parse("${baseUrl}voice"));
    if (response.statusCode == 200) {
      final r = jsonDecode(response.body) as List;
      return r.cast<String>();
    } else {
      throw Exception("Failed to load voice");
    }
  }
}
