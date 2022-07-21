import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  // TODO: implement routes
  List<Route> get routes => [
        Route.get('/user', _getAllUsers), //* Sem argumentos
        Route.get('/user/:id', _getUserById), //* Dados via argumento da url
        Route.post('/user', _createNewUser), //* Dados via json (body)
        Route.put('/user', _updateUser), //*
        Route.delete(
            '/user/:id', _deleteUserById), //* Dados via argumento da url
      ];

  FutureOr<Response> _getAllUsers() {
    return Response.ok('ok');
  }

  FutureOr<Response> _getUserById(ModularArguments arguments) {
    return Response.ok('User ${arguments.params['id']}');
  }

  FutureOr<Response> _createNewUser(ModularArguments arguments) {
    return Response.ok('User Created ${arguments.data}');
  }

  FutureOr<Response> _updateUser(ModularArguments arguments) {
    return Response.ok('User Updated ${arguments.data}');
  }

  FutureOr<Response> _deleteUserById(ModularArguments arguments) {
    return Response.ok('User Deleted ${arguments.params['id']}');
  }
}
