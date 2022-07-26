import 'package:bcrypt/bcrypt.dart';
import 'package:dart_simple_backend_shelf/src/core/services/bcrypt/bcrypt_service.dart';

class BCryptServiceImpl implements BCryptService {
  @override
  bool checkHash(String text, String hash) {
    return BCrypt.checkpw(text, hash);
  }

  @override
  String generateHash(String text) {
    final String hash = BCrypt.hashpw(text, BCrypt.gensalt());
    return hash;
  }
}
