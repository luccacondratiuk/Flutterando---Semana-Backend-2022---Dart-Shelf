import 'dart:async';

import 'package:dart_simple_backend_shelf/src/core/services/database/remote_database.dart';
import 'package:dart_simple_backend_shelf/src/core/services/dot_env/dot_env_service.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_modular/shelf_modular.dart';

class PostgresDatabase implements RemoteDatabase, Disposable {
  final completer = Completer<PostgreSQLConnection>();
  final DotEnvService dot_env;

  PostgresDatabase(this.dot_env) {
    _init();
  }

  _init() async {
    final url = dot_env['DATABASE_URL']!;
    final uri = Uri.parse(url);
    var connection = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first,
      username: uri.userInfo.split(":").first,
      password: uri.userInfo.split(":").last,
    );
    await connection.open();
    completer.complete(connection);
  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(String query_text,
      {Map<String, dynamic> variables = const {}}) async {
    final connection = await completer.future;
    return connection.mappedResultsQuery(query_text,
        substitutionValues: variables);
  }

  @override
  void dispose() async {
    final connection = await completer.future;
    await connection.close();
  }
}
