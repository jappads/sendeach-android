import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sms_sender_platform_interface.dart';

/// An implementation of [SmsSenderPlatform] that uses method channels.
class MethodChannelSmsSender extends SmsSenderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sms_sender');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> get isDefaultSmsApp async {
    return await methodChannel.invokeMethod<bool>('isDefaultSmsApp') ?? false;
  }

  @override
  Future<bool> setAsDefaultSmsApp() async {
    return await methodChannel.invokeMethod<bool>('setAsDefaultSmsApp') ??
        false;
  }

  @override
  Future<bool> deleteLastSentSms() async {
    return await methodChannel.invokeMethod<bool>('deleteLastSentSms') ?? false;
  }

  @override
  Future<void> sendSms(
    List<String> recipients,
    String message,
    Future<void> Function(String) onSmsSent,
    Future<void> Function(String) onSmsDelivered,
    int smsId, {
    bool deleteAfterSent = false,
    Future<void> Function(bool)? onLastSmsDeleted,
  }) async {
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "onSmsSent":
          onSmsSent(call.arguments);
          break;
        case "onSmsDelivered":
          onSmsDelivered(call.arguments);
          break;
        case "onLastSmsDeleted":
          onLastSmsDeleted?.call(call.arguments);
          break;
      }
    });
    await methodChannel.invokeMethod<bool>(
      'sendSms',
      {
        'recipients': recipients,
        'message': message,
        'deleteAfterSent': deleteAfterSent,
        'smsId': smsId,
      },
    );
  }
}
