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

+ (TikTokConfig *)configWithAccessToken:(NSString *)accessToken appID:(NSString *)appID environment: environment suppressAppTrackingDialog:(BOOL)isSuppressed
{
    return [[TikTokConfig alloc] initWithAccessToken:accessToken appID:appID environment: environment suppressAppTrackingDialog:isSuppressed];
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

- (id)initWithAccessToken:(NSString *)accessToken appID:(NSString *)appID environment: environment suppressAppTrackingDialog:(BOOL)isSuppressed
{
    self = [super init];
    
    if(self == nil) return nil;
    
    _accessToken = accessToken;
    _appID = appID;
    _isSuppressed = isSuppressed;
    _trackingEnabled = YES;
    _automaticTrackingEnabled = YES;
    _installTrackingEnabled = YES;
    _launchTrackingEnabled = YES;
    _retentionTrackingEnabled = YES;
    _paymentTrackingEnabled = YES;
    _tiktokEnvironment = environment;
    
    self.logger = [TikTokFactory getLogger];
    return self;
}

@end
