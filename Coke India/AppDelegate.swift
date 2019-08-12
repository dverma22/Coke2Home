//
//  AppDelegate.swift
//  Coke India
//
//  Created by IOS Development on 7/1/16.
//  Copyright © 2016 IOS Development. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabBarController: UITabBarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
//NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.tokenRefreshNotification),
//                                               name: .firInstanceIDTokenRefresh,
//                                               object: nil)
        
         let notificationType: UIUserNotificationType = [UIUserNotificationType.alert,UIUserNotificationType.badge,UIUserNotificationType.sound]
        
        let uiNotificationSetting = UIUserNotificationSettings(types: notificationType, categories: nil)
        
        application.registerForRemoteNotifications()
        
        application.registerUserNotificationSettings(uiNotificationSetting)
        
        
        
        UITabBar.appearance().tintColor = UIColor.white
        
        UITabBar.appearance().barTintColor = UIColor.red
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for:.normal)
        
        let selectedColor   = UIColor.black
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        
        FIRApp.configure()
        return true
    }
    
  
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var deviceTokenKey = ""
        for i in 0..<deviceToken.count {
            deviceTokenKey = deviceTokenKey + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
       
        print("Registration succeeded! Token: ", deviceTokenKey)
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
        UserDefaults.standard.setValue(deviceTokenKey, forKey: "tokenForFirebase")
        passDeviceToken()
        
    }
    func passDeviceToken()
    {
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token")
            {
                if let deviceToken = UserDefaults.standard.string(forKey: "tokenForFirebase"){
                    let tokenForFCM = "DeviceType=\(1)&DeviceId=\(deviceToken)"
                    let deviceTokenResponse = Api().postApiResponse(token as NSString, url: addDevice as NSString, post: tokenForFCM as NSString, method: "POST")
                    print(deviceTokenResponse)
                    print("devicetoken")
                }
            }
            else{
                print()
                print("token not generated")
            }
            
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Did Fail to Register for Remote Notifications")
        print("\(error), \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            //UserDefaults.standard.setValue(refreshedToken, forKey: "tokenForFirebase")
            passDeviceToken()
            //UserDefaults.standard.setValue(refreshedToken, forKey: "key2")
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    
    
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
                //UserDefaults.standard.setValue(error, forKey: "key2")
            } else {
                print("Connected to FCM.")
                //UserDefaults.standard.setValue("Connected", forKey: "key2")
            }
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("resign active")
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("did enter bg")
        //        self.window = UIWindow(frame: UIScreen.main.bounds)
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let initialViewController = storyboard.instantiateViewController(withIdentifier: "splashView")
        //        self.window?.rootViewController = initialViewController
        //        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("will enter")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "splashView")
//        self.window?.rootViewController = initialViewController
//        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
               // Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "Signin")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
      }
    
    
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //UserDefaults.standard.setValue(response.notification.request.content.userInfo, forKey: "key2")
        print("Userinfo \(response.notification.request.content.userInfo)")
        //    print("Userinfo \(response.notification.request.content.userInfo)")
        //UserDefaults.standard.setValue((response.notification.request.content.userInfo), forKey: "didre")
    }
}

extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
        // UserDefaults.standard.setValue(remoteMessage.appData, forKey: "key2")
    }
}

