import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:draw_on/draw_on.dart';

void main() {
  const MethodChannel channel = MethodChannel('draw_on');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DrawOn.platformVersion, '42');
  });
}
