import 'package:dart_simple_backend_shelf/dart_simple_backend_shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  //var pipeline = Pipeline().addMiddleware(log());
  final handler = await startShelfModular();
  final server = await io.serve(handler, '0.0.0.0', 4000);

  print("Online em ${server.address.address}:${server.port}");
}

// Middleware log() {
//   return (handler) {
//     return (request) async {
//       //* Antes de executar

//       print('Solicitação: ${request.url}');
//       var response = await handler(request);
//       //* Depois de executar
//       print('[${response.statusCode}] - Response Code');
//       return response;
//     };
//   };
// }

// FutureOr<Response> _handler(Request request) {
//   print(request);
//   return Response(200, body: "Corpo");
// }
