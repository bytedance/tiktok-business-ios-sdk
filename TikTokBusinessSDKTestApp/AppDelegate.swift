//
//  AppDelegate.swift
//  TikTokBusinessSDKTestApp
//
//  Created by Aditya Khandelwal on 9/10/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

import UIKit
/* ADD IMPORT STATEMENT HERE */
import TikTokBusinessSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Overriding Layout Constraint Warning Messages in Test App
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        /* UNCOMMENT DURING DEMO */
        let config = TikTokConfig.init(accessToken: Bundle.main.object(forInfoDictionaryKey: "TikTokAccessToken") as! String, appID: "com.shopee.my", environment: TikTokEnvironmentSandbox, suppressAppTrackingDialog: false)

        //        config?.disableTracking()
        
        /* ADD LINE HERE */
        TikTokBusiness.initializeSdk(config)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

