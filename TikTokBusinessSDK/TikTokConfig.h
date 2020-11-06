//
//  TikTokConfig.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TikTokLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface TikTokConfig : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *accessToken;
@property (nonatomic, copy, readonly, nonnull) NSString *appID;

@property (nonatomic, assign) TikTokLogLevel logLevel;

@property (nonatomic, assign) BOOL trackingEnabled;
@property (nonatomic, assign) BOOL automaticTrackingEnabled;
@property (nonatomic, assign) BOOL installTrackingEnabled;
@property (nonatomic, assign) BOOL launchTrackingEnabled;
@property (nonatomic, assign) BOOL retentionTrackingEnabled;
@property (nonatomic, assign) BOOL paymentTrackingEnabled;
@property (nonatomic, assign) BOOL appTrackingDialogSuppressed;
@property (nonatomic, assign) BOOL SKAdNetworkSupportEnabled;
@property (nonatomic, assign) BOOL userAgentCollectionEnabled;

+ (nullable TikTokConfig *)configWithAccessToken:(nonnull NSString *)accessToken
                                           appID:(nonnull NSString *)appID;

- (void)disableTracking;
- (void)disableAutomaticTracking;
- (void)disableInstallTracking;
- (void)disableLaunchTracking;
- (void)disableRetentionTracking;
- (void)disablePaymentTracking;
- (void)disableAppTrackingDialog;
- (void)disableSKAdNetworkSupportEnabled;
- (void)disableUserAgentCollectionEnabled;

- (nullable id)initWithAccessToken:(nonnull NSString *)accessToken
                             appID:(nonnull NSString *)appID;

@end

NS_ASSUME_NONNULL_END
