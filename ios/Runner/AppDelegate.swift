import UIKit
import Flutter
import AppsFlyerLib

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let pushChannel = FlutterMethodChannel(name: "com.fascode.attributable/push",
                                              binaryMessenger: controller.binaryMessenger)
    pushChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "measureUninstall" {
            // iOS 10 support
            if #available(iOS 10, *) {
              UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
              application.registerForRemoteNotifications()
            } else {
              UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
              UIApplication.shared.registerForRemoteNotifications()
            }
            result(true)
        }
    })
    
    let attChannel = FlutterMethodChannel(name: "com.fascode.attributable/att",
                                              binaryMessenger: controller.binaryMessenger)
    attChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "waitForATTUserAuthorization" {
            let timeoutSec = call.arguments as? Double ?? 60.0
            if #available(iOS 14, *) {
                AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: timeoutSec)
                NSLog("AppsFlyerLib.waitForATTUserAuthorization: \(timeoutSec)")
                result(true)
            } else {
                result(false)
            }
        }
    })
    
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        NSLog("[continue userActivity]")
        if #available(iOS 9.0, *) {
            AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        } else {
            
        }
        return true
    }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("[didRegisterForRemoteNotificationsWithDeviceToken deviceToken]")
        AppsFlyerLib.shared().registerUninstall(deviceToken)
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[didReceiveRemoteNotification userInfo]")
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        NSLog("[open url sourceApplication]")
        AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NSLog("[open url options]")
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
}
