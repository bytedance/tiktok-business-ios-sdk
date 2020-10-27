//
//  TikTokDeviceInfo.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/22/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokDeviceInfo : NSObject

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appNamespace;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *appBuild;
@property (nonatomic, copy) NSString *devicePlatform;
@property (nonatomic, copy) NSString *deviceIdForAdvertisers;
@property (nonatomic, copy) NSString *deviceVendorId;
@property (nonatomic, copy) NSString *localeInfo;
@property (nonatomic, copy) NSString *ipInfo;
@property (nonatomic, assign) BOOL trackingEnabled;
@property (nonatomic, copy) NSString *clientSdk;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, copy) NSString *machineModel;
@property (nonatomic, copy) NSString *cpuSubType;
@property (nonatomic, copy) NSString *osBuild;

- (id)initWithSdkPrefix:(NSString *)sdkPrefix;
+ (TikTokDeviceInfo *)deviceInfoWithSdkPrefix:(NSString *)sdkPrefix;
- (NSString *)getUserAgent;
- (NSString *)fallbackUserAgent;

@end

NS_ASSUME_NONNULL_END
