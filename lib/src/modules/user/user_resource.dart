import 'dart:async';
import 'dart:convert';

import 'package:dart_simple_backend_shelf/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/database/remote_database.dart';

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

  FutureOr<Response> _getAllUsers(Injector injector) async {
    final database = injector.get<RemoteDatabase>();
    final result =
        await database.query('SELECT id, name, email, role FROM "user";');
    final userList = result.map((e) => e['user']).toList();
    return Response.ok(jsonEncode(userList));
  }

  FutureOr<Response> _getUserById(
      ModularArguments arguments, Injector injector) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT id, name, email, role FROM "user" WHERE id = @id;',
        variables: {
          'id': id,
        });
    final userData = result.map((e) => e['user']).toList();
    return Response.ok(jsonEncode(userData));
  }

  FutureOr<Response> _createNewUser(
      ModularArguments arguments, Injector injector) async {
    final bcrypt = injector.get<BCryptService>();
    final userMap = (arguments.data as Map).cast<String, dynamic>();
    userMap.remove('id');
    userMap['password'] = bcrypt.generateHash(userMap['password']);
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'INSERT INTO "user" (name, email, password) VALUES( @name, @email, @password ) RETURNING id, email, role, name;',
        variables: userMap);
    final userData = result.map((e) => e['user']).first;
    return Response.ok(jsonEncode(userData));
  }

  FutureOr<Response> _updateUser(
      ModularArguments arguments, Injector injector) async {
    final userMap = (arguments.data as Map).cast<String, dynamic>();
    final database = injector.get<RemoteDatabase>();
    final columns = userMap.keys
        .where((key) => key != 'id' || key != 'password')
        .map((key) => '$key=@$key')
        .toList();
    final result = await database.query(
        'UPDATE "user" SET ${columns.join(',')} WHERE id=@id RETURNING id, email, role, name;',
        variables: userMap);
    final userData = result.map((e) => e['user']).toList();
    return Response.ok(jsonEncode(userData));
  }

  FutureOr<Response> _deleteUserById(
      ModularArguments arguments, Injector injector) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result =
        await database.query('DELETE FROM "user" WHERE id = @id;', variables: {
      'id': id,
    });
    final userList = result.map((e) => e['user']).toList();
    return Response.ok(jsonEncode({'message': 'Deleted User $id'}));
  }
}
