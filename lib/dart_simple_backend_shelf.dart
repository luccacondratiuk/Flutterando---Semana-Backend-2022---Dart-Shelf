import 'package:dart_simple_backend_shelf/src/app_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

Future<Handler> startShelfModular() async {
  //* Usar para iniciar outras coisas antes do servidor

  final handler = Modular(module: AppModule(), middlewares: [
    logRequests(),
    jsonResponse(),
  ]);
  return handler;
}

Middleware jsonResponse() {
  return (handler) {
    return (request) async {
      var response = await handler(request);
      response = response.change(
        headers: {
          'content-type': 'application/json',
          ...response.headers,
        },
      );
      return response;
    };
  };
}
