//
//  UIDevice+TikTokAdditions.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/22/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "TikTokDeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice(TikTokAdditions)

- (BOOL)tiktokUserTrackingEnabled;
- (NSString *)tiktokDeviceType;
- (NSString *)tiktokDeviceName;
- (NSString *)tiktokCreateUuid;
- (NSString *)tiktokVendorId;
- (NSString *)tiktokDeviceIp;
- (void)requestTrackingAuthorizationWithCompletionHandler: (void(^)(NSUInteger status))completion;
- (NSString *)getIPAddress:(BOOL)preferIPv4;
- (NSDictionary *)getIPAddresses;

@end

NS_ASSUME_NONNULL_END
