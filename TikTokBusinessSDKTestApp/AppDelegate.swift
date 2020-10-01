//
//  AppDelegate.swift
//  TikTokBusinessSDKTestApp
//
//  Created by Aditya Khandelwal on 9/10/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

import UIKit
import TikTokBusinessSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = TikTokConfig.init(appToken: "<YOUR APP TOKEN>", suppressAppTrackingDialog: false);
//        TikTokConfig.disableTracking()
//        TikTokConfig.disableAutomaticLogging()
//        TikTokConfig.disableInstallLogging()
//        TikTokConfig.disableLaunchLogging()
//        TikTokConfig.disableRetentionLogging()
//        TikTokConfig.disablePaymentLogging()
        TikTok.appDidLaunch(config);
        print("Developer Tracking is", TikTok.isTrackingEnabled() ? "enabled" : "disabled")
        print("User Tracking is", TikTok.isUserTrackingEnabled() ? "enabled": "disabled")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

