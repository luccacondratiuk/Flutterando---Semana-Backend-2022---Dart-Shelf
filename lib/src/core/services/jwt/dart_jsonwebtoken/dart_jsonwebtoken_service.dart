import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_simple_backend_shelf/src/core/services/dot_env/dot_env_service.dart';
import 'package:dart_simple_backend_shelf/src/core/services/jwt/jwt_service.dart';

class DartJsonWebTokenService implements JwtService {
  final DotEnvService dot_env_service;
  DartJsonWebTokenService(this.dot_env_service);
  @override
  String generateToken(Map claims, String audiance) {
    final jwt = JWT(claims, audience: Audience.one(audiance));
    final token = jwt.sign(SecretKey(dot_env_service['JWT_KEY']!));
    return token;
  }

  @override
  Map getPayload(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(dot_env_service['JWT_KEY']!),
      checkExpiresIn: false,
      checkHeaderType: false,
      checkNotBefore: false,
    );

    return jwt.payload;
  }

  @override
  void verifyToken(String token, String audiance) {
    final jwt = JWT.verify(
      token,
      SecretKey(dot_env_service['JWT_KEY']!),
      audience: Audience.one(audiance),
    );
  }
}
