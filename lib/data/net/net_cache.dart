import 'package:flutter/material.dart';
import 'package:live_musician/data/net/net.dart';
import 'package:live_musician/data/types/infer_file.dart';
import 'package:live_musician/data/types/separate_model.dart';
import 'package:live_musician/data/types/separate_sound.dart';
import 'package:live_musician/data/types/video_file.dart';

class NetCache {
  static String _domain = "";
  static Future<String> fetchDomain({bool forceRefresh = false}) async {
    if (!forceRefresh && _domain.isNotEmpty) return _domain;
    final r = "${await Net.queryDomain()}/lm/";
    if (r.isNotEmpty) {
      debugPrint("domain: $r");
      _domain = r;
      return r;
    }
    return "";
  }

  static List<SeparateModel> _separateModels = [];
  static Future<List<SeparateModel>> fetchSeparateModel({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _separateModels.isNotEmpty) {
      return _separateModels;
    }
    final r = await Net.fetchSeparateModel();
    if (r.isNotEmpty) {
      _separateModels = r;
      return r;
    }
    return [];
  }

  static List<String> _voice = [];
  static Future<List<String>> fetchVoice({bool forceRefresh = false}) async {
    if (!forceRefresh && _voice.isNotEmpty) {
      return _voice;
    }
    final r = await Net.fetchVoice();
    if (r.isNotEmpty) {
      _voice = r;
      return r;
    }
    return [];
  }

  static List<SeparateSound> _separateFiles = [];
  static Future<List<SeparateSound>> fetchSeparateFiles({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _separateFiles.isNotEmpty) {
      return _separateFiles;
    }
    final r = await Net.fetchSeparateFiles();
    if (r.isNotEmpty) {
      _separateFiles = r;
      return r;
    }
    return [];
  }

  static List<InferFile> _inferFiles = [];
  static Future<List<InferFile>> fetchInferFiles({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _inferFiles.isNotEmpty) {
      return _inferFiles;
    }
    final r = await Net.fetchInferFiles();
    if (r.isNotEmpty) {
      _inferFiles = r;
      return r;
    }
    return [];
  }

  static List<VideoFile> _videoFiles = [];
  static Future<List<VideoFile>> fetchVideoFiles({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _videoFiles.isNotEmpty) {
      return _videoFiles;
    }
    final r = await Net.fetchVideoFiles();
    if (r.isNotEmpty) {
      _videoFiles = r;
      return r;
    }
    return [];
  }
}
