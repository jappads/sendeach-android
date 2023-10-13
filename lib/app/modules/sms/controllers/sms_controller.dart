import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ja/app/data/services/sms_service.dart';
import 'package:sms_sender/sms_sender.dart';

class SmsController extends GetxController {
  late TextEditingController recipientsController;
  late TextEditingController messageController;

  @override
  void onInit() {
    recipientsController = TextEditingController();
    messageController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> sendSms() async {
    print('Sending Test SMS');
    print(recipientsController.text);
    print(messageController.text);

    await SmsSender().sendSms(
      recipientsController.text.split(','),
      messageController.text,
      onSMSSent,
      onSMSDelivered,
      1,
      deleteAfterSent: false,
      onLastSmsDeleted: (isSent) {
        return Future.value();
      },
    );
  }

  Future<void> onSMSSent(String arguments) async {
    try {
      var arg = jsonDecode(arguments);

      var success = arg['success'];
      var smsId = arg['smsId'];

      if (smsId != null) {
        if (!success) {
          print("smsFailed");
          Fluttertoast.showToast(msg: 'Failed to send SMS.');
        } else {
          print("smsSent");
          Fluttertoast.showToast(msg: 'SMS Sent Successfully.');
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> onSMSDelivered(String arguments) async {
    try {
      var arg = jsonDecode(arguments);

      var success = arg['success'];
      var smsId = arg['smsId'];

      if (smsId != null) {
        if (!success) {
          print("smsFailed");
          Fluttertoast.showToast(msg: 'Failed to Deliver SMS.');
        } else {
          print("smsDelivered");
          Fluttertoast.showToast(msg: 'SMS Delivered Successfully.');
        }
      }
    } catch (exception) {
      print(exception);
    }
  }
}
