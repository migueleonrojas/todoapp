import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';

void main() {
  group('Auth Bloc', () {
    test('props for state are empty', () {
      expect(Uninitialized().props, []);
    });
    test('Authenticated toString', () {
      final displayName = 'test';
      final uuid = 'abcd';
      expect(RemoteAuthenticated(displayName, uuid, false).toString(),
          'RemoteAuthenticated { displayName: $displayName, uuid: $uuid, newUser: false }');
    });
    test('Authenticated props', () {
      final displayName = 'test';
      final uuid = 'abcd';
      expect(RemoteAuthenticated(displayName, uuid, false).props,
          [displayName, uuid, false]);
    });
    test('Unauthenticated toString', () {
      final errorCode = 'abcd';
      expect(Unauthenticated(errorCode: errorCode).toString(),
          'Unauthenticated { errorCode: $errorCode }');
    });
    test('Unauthenticated props', () {
      final errorCode = 'abcd';
      expect(Unauthenticated(errorCode: errorCode).props, [errorCode]);
    });
  });
}
