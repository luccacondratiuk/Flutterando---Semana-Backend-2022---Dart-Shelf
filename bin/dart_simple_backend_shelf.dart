import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dart_simple_backend_shelf/dart_simple_backend_shelf.dart'
    as dart_simple_backend_shelf;

void main(List<String> arguments) async {
  final server = await io.serve(_handler, '0.0.0.0', 4000);

  print("Online em ${server.address.address}:${server.port}");
}

FutureOr<Response> _handler(Request request) {
  print(request);
  return Response(200, body: "Corpo");
}
