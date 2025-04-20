import 'package:live_musician/data/net.dart';
import 'package:live_musician/data/types/separate_model.dart';

class NetCache {
  static List<SeparateModel> _separateModels = [];
  static Future<List<SeparateModel>> fetchSeparateModel() async {
    if (_separateModels.isNotEmpty) {
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
  static Future<List<String>> fetchVoice() async {
    if (_voice.isNotEmpty) {
      return _voice;
    }
    final r = await Net.fetchVoice();
    if (r.isNotEmpty) {
      _voice = r;
      return r;
    }
    return [];
  }
}
