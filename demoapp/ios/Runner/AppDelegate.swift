import UIKit
import Flutter
import Smartech
import smartech_flutter_plugin


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SmartechDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
      Smartech.sharedInstance().setDebugLevel(.verbose)
      Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
      
      Smartech.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
      UNUserNotificationCenter.current().delegate = self
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Smartech.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Smartech.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Smartech.sharedInstance().willPresentForegroundNotification(notification)
        completionHandler([.alert, .badge, .sound])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        Smartech.sharedInstance().didReceive(response)
        completionHandler()
    }
     
    
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andCustomPayload customPayload: [AnyHashable : Any]?) {
        SwiftSmartechPlugin.handleDeeplinkAction(withURLString: deeplinkURLString, andCustomPayload: customPayload)
    }
}
