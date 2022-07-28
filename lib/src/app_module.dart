import 'package:dart_simple_backend_shelf/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:dart_simple_backend_shelf/src/core/services/bcrypt/bcrypt_service_impl.dart';
import 'package:dart_simple_backend_shelf/src/core/services/database/postgres/postgres_database.dart';
import 'package:dart_simple_backend_shelf/src/core/services/database/remote_database.dart';
import 'package:dart_simple_backend_shelf/src/core/services/dot_env/dot_env_service.dart';
<<<<<<< HEAD
import 'package:dart_simple_backend_shelf/src/modules/swagger/swagger_handler.dart';
=======
import 'package:dart_simple_backend_shelf/src/core/services/jwt/dart_jsonwebtoken/dart_jsonwebtoken_service.dart';
import 'package:dart_simple_backend_shelf/src/core/services/jwt/jwt_service.dart';
import 'package:dart_simple_backend_shelf/src/core/services/request_extractor/request_extractor.dart';
>>>>>>> a85101c (Aula 17: Login com JWT)
import 'package:dart_simple_backend_shelf/src/modules/user/user_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'modules/auth/auth_resource.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('Inicial')),
        Route.get('/documentation/**', swaggerHandler),
        Route.resource(UserResource()),
        Route.resource(AuthResource()),
      ];

  @override
  List<Bind> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService()),
        Bind.singleton<RemoteDatabase>((i) => PostgresDatabase(i())),
        Bind.singleton<BCryptService>((i) => BCryptServiceImpl()),
        Bind.singleton<RequestExtractor>((i) => RequestExtractor()),
        Bind.singleton<JwtService>((i) => DartJsonWebTokenService(i())),
      ];
}
