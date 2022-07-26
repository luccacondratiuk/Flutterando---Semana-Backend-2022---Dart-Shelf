import 'dart:io';

class DotEnvService {
  final Map<String, String> _map = {};

  DotEnvService({Map<String, String>? mocks}) {
    if (mocks == null) {
      _init();
    } else {
      _map.addAll(mocks);
    }
  }

  void _init() {
    final file = File('.env');
    final env_text = file.readAsStringSync();

    for (var line in env_text.split('\n')) {
      final line_break = line.split('=');
      _map[line_break[0]] = line_break[1];
    }
  }

  // String? getvalue(String key) {
  //   return _map[key];
  // }

  String? operator [](String key) {
    return _map[key];
  }
}
