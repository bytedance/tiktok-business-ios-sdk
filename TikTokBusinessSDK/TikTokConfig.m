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

@interface TikTokConfig()

@property (nonatomic, weak) id<TikTokLogger> logger;

@end

@implementation TikTokConfig: NSObject

+ (TikTokConfig *)configWithAccessToken:(NSString *)accessToken appID:(NSString *)appID environment: environment
{
    return [[TikTokConfig alloc] initWithAccessToken:accessToken appID:appID environment: environment];
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

- (void)disableSKAdNetworkSupportEnabled
{
    self.SKAdNetworkSupportEnabled = NO;
    [self.logger info:@"[TikTokConfig] SKAdNetwork Support: NO"];
}

- (void)disableUserAgentCollectionEnabled
{
    self.userAgentCollectionEnabled = NO;
    [self.logger info:@"[TikTokConfig] User Agent Collection: NO"];
}

- (id)initWithAccessToken:(NSString *)accessToken appID:(NSString *)appID environment: environment
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
    _tiktokEnvironment = environment;
    
    self.logger = [TikTokFactory getLogger];
    return self;
}

@end
