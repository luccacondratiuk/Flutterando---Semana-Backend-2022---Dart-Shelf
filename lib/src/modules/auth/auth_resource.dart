import 'dart:async';
import 'dart:convert';

import 'package:dart_simple_backend_shelf/src/core/services/bcrypt/bcrypt_service_impl.dart';
import 'package:dart_simple_backend_shelf/src/core/services/database/remote_database.dart';
import 'package:dart_simple_backend_shelf/src/core/services/jwt/dart_jsonwebtoken/dart_jsonwebtoken_service.dart';
import 'package:dart_simple_backend_shelf/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/bcrypt/bcrypt_service.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        // login
        Route.get('/auth/login', _login),
        // refresh_token
        Route.get('/auth/refresh_token', _refreshToken),
        // check_token
        Route.get('/auth/check_token', _checkToken),
        // update_password
        Route.post('/auth/update_password', _updatePassword),
      ];

  FutureOr<Response> _login(Request request, Injector injector) async {
    final extractor = injector.get<RequestExtractor>();
    final database = injector.get<RemoteDatabase>();
    final bcrypt = injector.get<BCryptService>();
    final jwt = injector.get<DartJsonWebTokenService>();
    final credential = extractor.getAuthorizationBasic(request);
    final result = await database.query(
        'SELECT id, role, password FROM "user" WHERE email = @email;',
        variables: {
          'email': credential.email,
        });

    if (result.isEmpty)
      return Response.forbidden(jsonEncode({'error': 'Credenciais Inválidas'}));
    final userMap = result.map((e) => e['user']).first;
    if (!bcrypt.checkHash(credential.password, userMap!['password']))
      return Response.forbidden(jsonEncode({'error': 'Credenciais Inválidas'}));

    final payload = userMap..remove('password');
    payload['exp'] = _determineExpiration(Duration(minutes: 10));
    final access_token = jwt.generateToken(payload, 'accessToken');

    payload['exp'] = _determineExpiration(Duration(days: 5));
    final refresh_token = jwt.generateToken(payload, 'refreshToken');

    return Response.ok(jsonEncode({
      'access_token': access_token,
      'refresh_token': refresh_token,
    }));
  }

  FutureOr<Response> _refreshToken() {
    return Response.ok('');
  }

  FutureOr<Response> _checkToken() {
    return Response.ok('');
  }

  FutureOr<Response> _updatePassword() {
    return Response.ok('');
  }

  int _determineExpiration(Duration duration) {
    final expires_date = DateTime.now().add(duration);
    final expires_in =
        Duration(milliseconds: expires_date.millisecondsSinceEpoch);
    return expires_in.inSeconds;
  }
}
