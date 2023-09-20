import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sms_sender/sms_sender_method_channel.dart';

void main() {
  MethodChannelSmsSender platform = MethodChannelSmsSender();
  const MethodChannel channel = MethodChannel('sms_sender');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
