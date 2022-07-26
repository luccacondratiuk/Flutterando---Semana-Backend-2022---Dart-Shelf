import 'package:dart_simple_backend_shelf/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:dart_simple_backend_shelf/src/core/services/bcrypt/bcrypt_service_impl.dart';
import 'package:dart_simple_backend_shelf/src/core/services/database/postgres/postgres_database.dart';
import 'package:dart_simple_backend_shelf/src/core/services/database/remote_database.dart';
import 'package:dart_simple_backend_shelf/src/core/services/dot_env/dot_env_service.dart';
import 'package:dart_simple_backend_shelf/src/modules/user/user_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('Inicial')),
        Route.resource(UserResource()),
      ];

  @override
  List<Bind> get binds => [
        Bind.instance<DotEnvService>(DotEnvService.instance),
        Bind.singleton<RemoteDatabase>((i) => PostgresDatabase(i())),
        Bind.singleton<BCryptService>((i) => BCryptServiceImpl()),
      ];
}
