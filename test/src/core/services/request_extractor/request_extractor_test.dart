import 'dart:convert';

import 'package:dart_simple_backend_shelf/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final extractor = RequestExtractor();
  test('getAuthorizationBearer', () async {
    final request = Request('GET', Uri.parse('http://localhost/test'),
        headers: {'authorization': 'bearer çoddcghowe83478rikdsgbc873'});
    final token = extractor.getAuthorizationBearer(request);
    expect(token, 'çoddcghowe83478rikdsgbc873');
  });

  test('getAuthorizationBasic', () async {
    final credential_auth =
        base64Encode('exemplo@exemplo.com:987654321'.codeUnits);
    final request = Request('GET', Uri.parse('http://localhost/test'),
        headers: {'authorization': credential_auth});
    final token = extractor.getAuthorizationBasic(request);
    expect(token.email, 'exemplo@exemplo.com');
    expect(token.password, '987654321');
  });
}
