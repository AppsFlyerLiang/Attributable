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
    let batteryChannel = FlutterMethodChannel(name: "com.fascode.attributable/push",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "measureUninstall" {
            // iOS 10 support
            if #available(iOS 10, *) {
              UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
              application.registerForRemoteNotifications()
            } else if #available(iOS 8, *), #available(iOS 9, *) {
              UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
              UIApplication.shared.registerForRemoteNotifications()
            }
            result(true)
        }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        NSLog("[continue userActivity]")
        if #available(iOS 9.0, *) {
            AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
        } else {
            
        }
        return true
    }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("[didRegisterForRemoteNotificationsWithDeviceToken deviceToken]")
        AppsFlyerTracker.shared().registerUninstall(deviceToken)
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[didReceiveRemoteNotification userInfo]")
        AppsFlyerTracker.shared().handlePushNotification(userInfo)
    }
    override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        NSLog("[open url sourceApplication]")
        AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NSLog("[open url options]")
        AppsFlyerTracker.shared().handleOpen(url, options: options)
        return true
    }
}
