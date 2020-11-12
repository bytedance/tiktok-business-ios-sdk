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
        let config = TikTokConfig.init(accessToken: Bundle.main.object(forInfoDictionaryKey: "TikTokAccessToken") as! String, appID: "com.shopee.my")
        
        /* UNCOMMENT TO DISABLE OPTIONS BEFORE INITIALIZING SDK
        
        config?.disableTracking()                       // Disable All Tracking
        config?.disableAutomaticTracking()              // Disable All Automatic Tracking
        config?.disableInstallTracking()                // Disable Automatic Install Tracking
        config?.disableLaunchTracking()                 // Disable Automatic Launch Tracking
        config?.disableRetentionTracking()              // Disable Automatic 2DRetention Tracking
        config?.disablePaymentTracking()                // Disable Automatic Payment Tracking
        config?.disableAppTrackingDialog()              // Disable App Tracking Transparency Dialog
        config?.disableSKAdNetworkSupport()             // Disable SKAdNetwork Support
        config?.disableUserAgentCollection()            // Disable User Agent Collection
        config?.setLogLevel(TikTokLogLevelVerbose)
        config?.setCustomUserAgent("THIS IS A CUSTOM USER AGENT")
        
        */
        
        /*
        

        
        */
        
        /* ADD LINE HERE */
        TikTokBusiness.initializeSdk(config)

        /* UNCOMMENT TO CUSTOMIZE AFTER INITIALIZING SDK
 
        TikTokBusiness.setTrackingEnabled(/* value */)
        TikTokBusiness.setAutomaticTrackingEnabled(/* value */)
        TikTokBusiness.setRetentionTrackingEnabled(/* value */)
        TikTokBusiness.setPaymentTrackingEnabled(/* value */)
        TikTokBusiness.setAppTrackingDialog(/* value */)
        TikTokBusiness.setSKAdNetworkSupport(/* value */)
        
        */
        
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

