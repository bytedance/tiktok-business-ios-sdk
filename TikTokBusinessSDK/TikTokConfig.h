//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import "TikTokLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface TikTokConfig : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *accessToken;
@property (nonatomic, copy, readonly, nonnull) NSString *appId;
@property (nonatomic, readonly) NSNumber * tiktokAppId;
@property (nonatomic, assign) BOOL trackingEnabled;
@property (nonatomic, assign) BOOL automaticTrackingEnabled;
@property (nonatomic, assign) BOOL installTrackingEnabled;
@property (nonatomic, assign) BOOL launchTrackingEnabled;
@property (nonatomic, assign) BOOL retentionTrackingEnabled;
@property (nonatomic, assign) BOOL paymentTrackingEnabled;
@property (nonatomic, assign) BOOL appTrackingDialogSuppressed;
@property (nonatomic, assign) BOOL SKAdNetworkSupportEnabled;
@property (nonatomic, assign) BOOL userAgentCollectionEnabled;

@property (nonatomic) long initialFlushDelay;

+ (nullable TikTokConfig *)configWithAccessToken:(NSString *)accessToken
                                           appId:(NSString *)appId
                                     tiktokAppId:(NSNumber *)tiktokAppId;

- (void)disableTracking;
- (void)disableAutomaticTracking;
- (void)disableInstallTracking;
- (void)disableLaunchTracking;
- (void)disableRetentionTracking;
- (void)disablePaymentTracking;
- (void)disableAppTrackingDialog;
- (void)disableSKAdNetworkSupport;
- (void)setCustomUserAgent:(NSString *)customUserAgent;
- (void)setLogLevel:(TikTokLogLevel)logLevel;
- (void)setDelayForATTUserAuthorizationInSeconds:(long)seconds;

- (nullable id)initWithAccessToken:(NSString *)accessToken
                             appId:(NSString *)appId
                       tiktokAppId:(NSNumber *)tiktokAppId;

@end

NS_ASSUME_NONNULL_END
