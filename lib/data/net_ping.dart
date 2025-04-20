import 'dart:async';

import 'package:live_musician/data/net.dart';

class NetPing {
  static NetPing? _instance;
  static NetPing get instance {
    _instance ??= NetPing();
    return _instance!;
  }

  Duration? lastPingDuration;
  int _pingFailCount = 0;
  bool get isPingFail => _pingFailCount > 3;

  NetPing() {
    ping().then((v) => lastPingDuration = v);
    Timer.periodic(const Duration(seconds: 10), (_) async {
      final p = await ping();
      if (p == null) {
        _pingFailCount++;
      } else {
        _pingFailCount = 0;
        lastPingDuration = p;
      }
    });
  }

  Future<Duration?> ping() => Net.ping();
}
