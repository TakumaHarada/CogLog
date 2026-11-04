import 'package:flutter_test/flutter_test.dart';
import 'package:foundation_metadata/foundation_metadata.dart';

void main() {
  test('test flavor の FLAVOR を dart-define JSON から読む', () {
    expect(Defines.FLAVOR, 'development');
  });
}
