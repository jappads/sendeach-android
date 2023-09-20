import 'package:background_sms/background_sms.dart';

class Sms {
  int id;
  String message;
  int androidDeviceId;
  List<String> to;
  String batchId;
  DateTime initiatedTime;
  int smsType;
  DateTime createdAt;

  Sms({required this.id,
    required this.message,
    required this.androidDeviceId,
    required this.to,
    required this.batchId,
    required this.initiatedTime,
    required this.smsType,
    required this.createdAt});

  //Create fromJson function
  factory Sms.fromJson(Map<String, dynamic> json) {
    return Sms(
      id: json['id'],
      message: json['message'],
      androidDeviceId: json['android_device_id'],
      to: List<String>.from(json['to'].toString().split(", ")),
      batchId: json['batch_id'],
      initiatedTime: DateTime.parse(json['initiated_time']),
      smsType: json['sms_type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static sendSms(String message, List<String> recipients) async {
    try {
      for(var to in recipients){
        var result = await BackgroundSms.sendMessage(
            phoneNumber: to, message: message);
        if (result == SmsStatus.sent) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
