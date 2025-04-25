import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'CF_URL')
  static const String cfUrl = _Env.cfUrl;

  @EnviedField(varName: 'CF_KEY')
  static const String cfKey = _Env.cfKey;
}

// dart run build_runner build
