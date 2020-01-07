import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_browser/file_browser.dart';

void main() {
  const MethodChannel channel = MethodChannel('file_browser');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FileBrowser.platformVersion, '42');
  });
}
