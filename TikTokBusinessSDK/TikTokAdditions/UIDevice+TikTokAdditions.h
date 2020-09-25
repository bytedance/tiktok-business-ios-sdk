//
//  UIDevice+TikTokAdditions.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/22/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TikTokDeviceInfo.h>
#import <TikTokAppEventQueue.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <AdSupport/AdSupport.h>
#import <AdSupport/ASIdentifierManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice(TikTokAdditions)

- (int)tiktokATTStatus;
- (BOOL)tiktokTrackingEnabled;
- (NSString *)tiktokIdForAdvertisers;
- (NSString *)tiktokDeviceType;
- (NSString *)tiktokDeviceName;
- (NSString *)tiktokCreateUuid;
- (NSString *)tiktokVendorId;
//- (NSString *)tiktokDeviceId: (TikTokDeviceInfo *)deviceInfo;
- (NSString *)tiktokDeviceIp;
//- (void) tiktokCheckForiAd: (TikTokAppEventQueue *)appEventQueue queue:(dispatch_queue_t)queue;
- (void)requestTrackingAuthorizationWithCompletionHandler: (void(^)(NSUInteger status))completion;
- (NSString *)getIPAddress:(BOOL)preferIPv4;
- (NSDictionary *)getIPAddresses;

@end

NS_ASSUME_NONNULL_END
