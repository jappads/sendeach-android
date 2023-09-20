import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sms_sender_method_channel.dart';

abstract class SmsSenderPlatform extends PlatformInterface {
  /// Constructs a SmsSenderPlatform.
  SmsSenderPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmsSenderPlatform _instance = MethodChannelSmsSender();

  /// The default instance of [SmsSenderPlatform] to use.
  ///
  /// Defaults to [MethodChannelSmsSender].
  static SmsSenderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmsSenderPlatform] when
  /// they register themselves.
  static set instance(SmsSenderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> get isDefaultSmsApp {
    throw UnimplementedError('isDefaultSmsApp() has not been implemented.');
  }

  Future<bool> setAsDefaultSmsApp() {
    throw UnimplementedError('setAsDefaultSmsApp() has not been implemented.');
  }

  Future<bool> deleteLastSentSms(){
    throw UnimplementedError('deleteLastSentSms() has not been implemented.');
  }

  Future<void> sendSms(
      List<String> recipients,
      String message,
      Future<void> Function(String) onSmsSent,
      Future<void> Function(String) onSmsDelivered, int smsId,
      {
        bool deleteAfterSent = false,
        Future<void> Function(bool)? onLastSmsDeleted,
      }
      )  {
    throw UnimplementedError('sendSms() has not been implemented.');
  }
}
