import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:live_musician/data/types/infer_file.dart';
import 'package:live_musician/data/types/separate_model.dart';
import 'package:live_musician/data/types/separate_sound.dart';

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

  // 拉取数据

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

  static Future<List<SeparateSound>> fetchSeparateFiles() async {
    final response = await http.get(Uri.parse("${baseUrl}separate_files"));
    if (response.statusCode == 200) {
      final r = jsonDecode(response.body);
      return r.entries
          .map((e) => SeparateSound.fromJson(e))
          .toList()
          .cast<SeparateSound>();
      // return r.map((key, value) => MapEntry(key, List<String>.from(value)));
    } else {
      throw Exception("Failed to load separate files");
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

  static Future<List<InferFile>> fetchInferFiles() async {
    final response = await http.get(Uri.parse("${baseUrl}voice_infer_files"));
    if (response.statusCode == 200) {
      final r = jsonDecode(response.body) as List;
      return r.map((e) => InferFile.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load infer files");
    }
  }

  // 拉取文件
  static Future<Uint8List?> fetchFile(
    String cate,
    String name,
    String file,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}file/$cate/$name/$file"),
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception("Failed to load file");
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<Uint8List?> fetchFileSeparate(String name, String file) =>
      fetchFile("separate", name, file);

  static Future<Uint8List?> fetchFileInfer(String seed) =>
      fetchFile("change", seed, "1.wav");

  // 提交算题

  // 分离音色
  static Future<bool> seperate(
    String taskName,
    SeparateModel model,
    Uint8List data,
  ) async {
    try {
      final uri = Uri.parse("${baseUrl}separate");
      final request =
          http.MultipartRequest("POST", uri)
            ..fields['taskName'] = taskName
            ..fields['model'] = model.model
            ..files.add(
              http.MultipartFile.fromBytes("file", data, filename: "audio"),
            );
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // 音色训练
  static Future<bool> voiceTrain(String taskName, Uint8List data) async {
    try {
      final uri = Uri.parse("${baseUrl}voice_train");
      final request =
          http.MultipartRequest("POST", uri)
            ..fields['taskName'] = taskName
            ..files.add(
              http.MultipartFile.fromBytes("file", data, filename: "archive"),
            );
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // 声音推理
  static Future<bool> voiceInfer(String toneName, String musicName) async {
    try {
      final uri = Uri.parse("${baseUrl}voice_infer");
      final request =
          http.MultipartRequest("POST", uri)
            ..fields['toneName'] = toneName
            ..fields['musicName'] = musicName;

      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
