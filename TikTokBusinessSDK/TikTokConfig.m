//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
//

#import "TikTokConfig.h"
#import "TikTokLogger.h"
#import "TikTokBusiness.h"
#import "TikTokFactory.h"
#import "TikTokUserAgentCollector.h"

@interface TikTokConfig()

@property (nonatomic, weak) id<TikTokLogger> logger;
@property (nonatomic, assign) TikTokLogLevel logLevel;

@end

@implementation TikTokConfig: NSObject

+ (TikTokConfig *)configWithAccessToken:(nullable NSString *)accessToken appID:(nullable NSString *)appID tiktokAppID:(nullable NSString *)tiktokAppID
{
    return [[TikTokConfig alloc] initWithAccessToken:accessToken appID:appID tiktokAppID:tiktokAppID];
}

- (void)disableTracking
{
    self.trackingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Tracking: NO"];
}

- (void)disableAutomaticTracking
{
    self.automaticTrackingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Auto Tracking: NO"];
}

- (void)disableInstallTracking
{
    self.installTrackingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Install Tracking: NO"];
}

- (void)disableLaunchTracking
{
    self.launchTrackingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Launch Tracking: NO"];
}

- (void)disableRetentionTracking
{
    self.retentionTrackingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Retention Tracking: NO"];
}

- (void)disablePaymentTracking
{
    self.paymentTrackingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Payment Tracking: NO"];
}

- (void)disableAppTrackingDialog
{
    self.appTrackingDialogSuppressed = YES;
    [self.logger info:@"[TikTokConfig] AppTrackingTransparency dialog has been suppressed"];
}

- (void)disableSKAdNetworkSupport
{
    self.SKAdNetworkSupportEnabled = NO;
    [self.logger info:@"[TikTokConfig] SKAdNetwork Support: NO"];
}

- (void)setCustomUserAgent: (NSString *)customUserAgent
{
    [[TikTokUserAgentCollector singleton] setUserAgent:customUserAgent];
    [self.logger info:@"[TikTokConfig] User Agent set to: %@", customUserAgent];
}

-(void)setLogLevel:(TikTokLogLevel)logLevel
{
    _logLevel = logLevel;
    [self.logger setLogLevel:logLevel];
}

- (void)setDelayForATTUserAuthorizationInSeconds: (long)seconds
{
    self.initialFlushDelay = seconds;
    [self.logger info:@"[TikTokConfig] Initial flush delay set to: %lu", seconds];
}

- (id)initWithAccessToken:(nullable NSString *)accessToken appID:(nullable NSString *)appID tiktokAppID:(nullable NSString *)tiktokAppID
{
    self = [super init];
    
    if(self == nil) return nil;
    
    _accessToken = accessToken;
    _appID = appID;
    _tiktokAppID = tiktokAppID;
    _trackingEnabled = YES;
    _automaticTrackingEnabled = YES;
    _installTrackingEnabled = YES;
    _launchTrackingEnabled = YES;
    _retentionTrackingEnabled = YES;
    _paymentTrackingEnabled = YES;
    _appTrackingDialogSuppressed = NO;
    _SKAdNetworkSupportEnabled = YES;
    _userAgentCollectionEnabled = YES;
    
    self.logger = [TikTokFactory getLogger];
    return self;
}

@end
