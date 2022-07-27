import 'package:dart_simple_backend_shelf/src/core/services/dot_env/dot_env_service.dart';
import 'package:dart_simple_backend_shelf/src/core/services/jwt/dart_jsonwebtoken/dart_jsonwebtoken_service.dart';
import 'package:test/test.dart';

void main() {
  test('Get JWT', () async {
    final DotEnvService dot_env_service =
        DotEnvService(mocks: {'JWT_KEY': 'ladfhlalsdkhfasldfhaçsoidfy930'});
    final jwt = DartJsonWebTokenService(dot_env_service);
    final date_exp = DateTime.now().add(Duration(seconds: 30));
    final expires =
        Duration(milliseconds: date_exp.millisecondsSinceEpoch).inSeconds;
    final token = jwt.generateToken({
      'id': 1,
      'role': 'user',
      'exp': expires,
    }, 'accessToken');
    print(token);
  });

  test('Check JWT', () async {
    final DotEnvService dot_env_service =
        DotEnvService(mocks: {'JWT_KEY': 'ladfhlalsdkhfasldfhaçsoidfy930'});
    final jwt = DartJsonWebTokenService(dot_env_service);
    jwt.verifyToken(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6InVzZXIiLCJleHAiOjE2NTg4ODE4NjIsImlhdCI6MTY1ODg4MTgzMiwiYXVkIjoiYWNjZXNzVG9rZW4ifQ.ZH6hlFeGGCu6OmoA3T4hhrJNmEV2GZbJE41EVzbpg0k',
      'accessToken',
    );
  });

  test('Payload JWT', () async {
    final DotEnvService dot_env_service =
        DotEnvService(mocks: {'JWT_KEY': 'ladfhlalsdkhfasldfhaçsoidfy930'});
    final jwt = DartJsonWebTokenService(dot_env_service);
    final payload = jwt.getPayload(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6InVzZXIiLCJleHAiOjE2NTg4ODE4NjIsImlhdCI6MTY1ODg4MTgzMiwiYXVkIjoiYWNjZXNzVG9rZW4ifQ.ZH6hlFeGGCu6OmoA3T4hhrJNmEV2GZbJE41EVzbpg0k');
    print(payload);
  });
}
