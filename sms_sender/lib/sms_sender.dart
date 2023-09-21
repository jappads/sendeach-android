import 'sms_sender_platform_interface.dart';

class SmsSender {
  Future<String?> getPlatformVersion() {
    return SmsSenderPlatform.instance.getPlatformVersion();
  }

  Future<void> sendSms(
      List<String> recipients,
      String message,
      Future<void> Function(String) onSmsSent,
      Future<void> Function(String  ) onSmsDelivered, int smsId,
      {
        bool deleteAfterSent = false,
        Future<void> Function(bool)? onLastSmsDeleted,
      }
      )  async {
    return SmsSenderPlatform.instance.sendSms(
      recipients,
      message,
        onSmsSent,
      onSmsDelivered,
      smsId,
      deleteAfterSent: deleteAfterSent,
      onLastSmsDeleted: onLastSmsDeleted,
    );
  }

  static Future<bool> get isDefaultSmsApp async {
    return await SmsSenderPlatform.instance.isDefaultSmsApp;
  }

  static Future<bool> setAsDefaultSmsApp()async {
    return await SmsSenderPlatform.instance.setAsDefaultSmsApp();
  }

  Future<bool> deleteLastSentSms()async {
    return await SmsSenderPlatform.instance.deleteLastSentSms();
  }
}
