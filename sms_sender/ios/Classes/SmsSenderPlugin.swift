import Flutter
import UIKit
import MessageUI

public class SmsSenderPlugin: NSObject, FlutterPlugin {

    private var channel: FlutterMethodChannel
    var result: FlutterResult?
    var recipients: [String]?
    var message: String?
    var sentCompletionHandler: ((Bool) -> Void)?
    var deliveredCompletionHandler: ((Bool) -> Void)?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sms_sender", binaryMessenger: registrar.messenger())
        let instance = SmsSenderPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    init(channel: FlutterMethodChannel) {
      self.channel = channel
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "sendSms" {
            if let args = call.arguments as? [String: Any] {
                recipients = args["recipients"] as? [String]
                message = args["message"] as? String
                sentCompletionHandler = { (success) in
                    self.channel.invokeMethod("onSentListener",arguments: success)
                    result(nil)
                }
                deliveredCompletionHandler = { (success) in
                    self.channel.invokeMethod("onDeliveredListener",arguments: success)
                    result(nil)
                }
                sendSMS()
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    func sendSMS() {
        if MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = recipients
            composeVC.body = message
            UIApplication.shared.keyWindow?.rootViewController?.present(composeVC, animated: true, completion: nil)
        } else {
            sentCompletionHandler?(false)
        }
    }
}

extension SmsSenderPlugin: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            sentCompletionHandler?(false)
            deliveredCompletionHandler?(false)
        case .failed:
            sentCompletionHandler?(false)
            deliveredCompletionHandler?(false)
        case .sent:
            sentCompletionHandler?(true)
            deliveredCompletionHandler?(true)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
