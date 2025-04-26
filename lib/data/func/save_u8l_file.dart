import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

void saveUint8listToFile(Uint8List data, String filePath) {
  // final file = File(filePath ?? 'test.wav');
  final file = File(filePath);
  file.writeAsBytesSync(data);
}

Future<String> saveUint8listToFileTemp(
  Uint8List data, [
  String suffix = "",
]) async {
  final r = await getApplicationCacheDirectory();
  final t = DateTime.now().millisecondsSinceEpoch;
  final p = "${r.path}/$t$suffix";
  saveUint8listToFile(data, p);
  return p;
}
