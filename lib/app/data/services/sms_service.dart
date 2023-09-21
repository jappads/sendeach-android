import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ja/app/data/models/sms.dart';
import 'package:ja/app/data/services/auth_service.dart';
import 'package:ja/app/data/services/device_info_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ja/app/data/providers/sms_provider.dart';
import 'package:ja/app/data/repositories/sms_repository.dart';
import 'package:ja/app/data/services/pref_service.dart';
import 'package:sms_sender/sms_sender.dart';

class SMSService extends GetxService {
  late final GetStorage _box;
  late bool isDefaultSmsApp;

  Future<SMSService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    isDefaultSmsApp = await SmsSender.isDefaultSmsApp;
    Get.put(SmsRepository());
    await Get.putAsync(() => DeviceInfoService().init());
    await Get.putAsync(() => AuthService().init());
    return this;
  }

  Future setAsDefaultSmsApp() async {
    await SmsSender.setAsDefaultSmsApp();
  }

  Future saveSmsId(int? smsId) async {
    return await _box.write("smsId", smsId);
  }

  int? readSmsId() {
    return _box.read<int>("smsId");
  }

  void sendSMS({
    required TextEditingController recipientsController,
    required TextEditingController messageController,
  }) async {
    await Permission.sms.request();
    List<String> recipients = recipientsController.text.split(",");
    await SmsSender().sendSms(
      recipients,
      messageController.text,
      _onSent,
      _onDelivered,
      0,
      deleteAfterSent: Get.find<PrefService>().deleteAfterSent.value,
      onLastSmsDeleted: _onLastSmsDeleted,
    );
  }

  Future sendSms(RemoteMessage remoteMessage) async {
    await init();
    var data = await Get.find<SmsRepository>().getPendingSms();

    while (data.isNotEmpty) {
      for (final sms in data) {
        await saveSmsId(sms.id);
        await Get.putAsync(() => PrefService().init());
        await SmsSender().sendSms(
          sms.to,
          sms.message,
          _onSent,
          _onDelivered,
          sms.id,
          deleteAfterSent: Get.find<PrefService>().deleteAfterSent.value,
          onLastSmsDeleted: _onLastSmsDeleted,
        );
      }

      data = await Get.find<SmsRepository>().getPendingSms();
    }
  }

  Future _onSent(String arguments) async {
    // var smsId = readSmsId();
    // No need to update Processing Status as sms is automatically updated to processing when it is pulled
    var arg = jsonDecode(arguments);
    var success = arg['success'];
    var smsId = arg['smsId'];

    if (smsId != 0 && !success) {
      await Get.find<SmsRepository>().updateStatus(
          smsId, success ? SmsStatus.sent : SmsStatus.failed);
    }
    Fluttertoast.showToast(msg: "Sms sent");
  }

  Future _onDelivered(String arguments) async {
    // var smsId = readSmsId();
    var arg = jsonDecode(arguments);

    var success = arg['success'];
    var smsId = arg['smsId'];

    if (smsId != null) {
      await Get.find<SmsRepository>().updateStatus(smsId, success ? SmsStatus.delivered: SmsStatus.failed);
    }
    Fluttertoast.showToast(msg: "Sms Delivered");
  }

  Future _onLastSmsDeleted(bool success) async {
    Fluttertoast.showToast(msg: "Last Sms Deleted");
  }
}
