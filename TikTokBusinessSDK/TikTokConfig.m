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

+ (TikTokConfig *)configWithAccessToken:(NSString *)accessToken appID:(NSString *)appID suppressAppTrackingDialog:(BOOL)isSuppressed
{
    return [[TikTokConfig alloc] initWithAccessToken:accessToken appID:appID suppressAppTrackingDialog:isSuppressed];
}

- (void)disableTracking
{
    self.trackingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Tracking: NO"];
}

- (void)disableAutomaticLogging
{
    self.automaticLoggingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Auto Tracking: NO"];
}

- (void)disableInstallLogging
{
    self.installLoggingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Install Tracking: NO"];
}

- (void)disableLaunchLogging
{
    self.launchLoggingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Launch Tracking: NO"];
}

- (void)disableRetentionLogging
{
    self.retentionLoggingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Retention Tracking: NO"];
}

- (void)disablePaymentLogging
{
    self.paymentLoggingEnabled = NO;
    [self.logger info:@"[TikTokConfig] Payment Tracking: NO"];
}

- (id)initWithAccessToken:(NSString *)accessToken appID:(NSString *)appID suppressAppTrackingDialog:(BOOL)isSuppressed
{
    self = [super init];
    
    if(self == nil) return nil;
    
    _accessToken = accessToken;
    _appID = appID;
    _isSuppressed = isSuppressed;
    _trackingEnabled = YES;
    _automaticLoggingEnabled = YES;
    _installLoggingEnabled = YES;
    _launchLoggingEnabled = YES;
    _retentionLoggingEnabled = YES;
    _paymentLoggingEnabled = YES;
    
    self.logger = [TikTokFactory getLogger];
    return self;
}

@end
