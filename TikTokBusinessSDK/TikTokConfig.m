//
//  TikTokConfig.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
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

+ (TikTokConfig *)configWithAccessToken:(NSString *)accessToken appID:(NSString *)appID
{
    return [[TikTokConfig alloc] initWithAccessToken:accessToken appID:appID];
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

- (id)initWithAccessToken:(NSString *)accessToken appID:(NSString *)appID
{
    self = [super init];
    
    if(self == nil) return nil;
    
    _accessToken = accessToken;
    _appID = appID;
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
