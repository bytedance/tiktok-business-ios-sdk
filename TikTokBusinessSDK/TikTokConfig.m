//
//  TikTokConfig.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokConfig.h"
#import "TikTokLogger.h"
#import "TikTok.h"

@interface TikTokConfig()

@property (nonatomic, weak) id<TikTokLogger> logger;

@end

@implementation TikTokConfig: NSObject

+ (TikTokConfig *)configWithAppToken:(NSString *)appToken suppressAppTrackingDialog:(BOOL)isSuppressed
{
    return [[TikTokConfig alloc] initWithAppToken:appToken suppressAppTrackingDialog:isSuppressed];
}

+ (void)disableTracking
{
    [[TikTok getInstance] setTrackingEnabled:NO];
//    [[[TikTokLogger alloc] init] info:@"Tracking has been disabled"];
}

- (void)disableTracking
{
    [self.logger info:@"Tracking has been disabled!"];
    [[TikTok getInstance] setTrackingEnabled:NO];
}

+ (void)disableAutomaticLogging
{
    [[TikTok getInstance] setAutomaticLoggingEnabled:NO];
}

- (void)disableAutomaticLogging
{
    [self.logger info:@"Tracking has been disabled!"];
    [[TikTok getInstance] setAutomaticLoggingEnabled:NO];
}

+ (void)disableInstallLogging
{
    [[TikTok getInstance] setInstallLoggingEnabled:NO];
}

- (void)disableInstallLogging
{
    [self.logger info:@"Tracking has been disabled!"];
    [[TikTok getInstance] setInstallLoggingEnabled:NO];
}

+ (void)disableLaunchLogging
{
    [[TikTok getInstance] setLaunchLoggingEnabled:NO];
}

- (void)disableLaunchLogging
{
    [self.logger info:@"Tracking has been disabled!"];
    [[TikTok getInstance] setLaunchLoggingEnabled:NO];
}

+ (void)disableRetentionLogging
{
    [[TikTok getInstance] setRetentionLoggingEnabled:NO];
}

- (void)disableRetentionLogging
{
    [self.logger info:@"Tracking has been disabled!"];
    [[TikTok getInstance] setRetentionLoggingEnabled:NO];
}

+ (void)disablePaymentLogging
{
    [[TikTok getInstance] setPaymentLoggingEnabled:NO];
}

- (void)disablePaymentLogging
{
    [self.logger info:@"Payment Logging has been disabled!"];
    [[TikTok getInstance] setPaymentLoggingEnabled:NO];
}

- (id)initWithAppToken:(NSString *)appToken suppressAppTrackingDialog:(BOOL)isSuppressed
{
    self = [super init];
    
    if(self == nil) return nil;
    
    _appToken = appToken;
    _isSuppressed = isSuppressed;
//    _secretId = appSecret;

    self.logger = [[TikTok alloc] init].logger;
    [self.logger info: @"TikTokConfig was valid!"];
    return self;
}
//
//- (BOOL)isValid
//{
//
////    if [NSString ]
//}

//
//- (id)initWithAppToken:(NSString *)appToken
//           environment:(NSString *)environment
//{
//    return [self initWithAppToken:appToken
//                      environment:environment
//             allowSuppressLogLevel:NO];
//}
//
//- (id)initWithAppToken:(NSString *)appToken
//           environment:(NSString *)environment
//  allowSuppressLogLevel:(BOOL)allowSuppressLogLevel
//{
//    self = [super init];
//    if (self == nil) return nil;
//
//    self.logger = ADJAdjustFactory.logger;
//    // default values
//    if (allowSuppressLogLevel && [ADJEnvironmentProduction isEqualToString:environment]) {
//        [self setLogLevel:ADJLogLevelSuppress environment:environment];
//    } else {
//        [self setLogLevel:ADJLogLevelInfo environment:environment];
//    }
//
//    if (![self checkEnvironment:environment]) return self;
//    if (![self checkAppToken:appToken]) return self;
//
//    _appToken = appToken;
//    _environment = environment;
//
//    // default values
//    self.sendInBackground = NO;
//    self.eventBufferingEnabled = NO;
//    self.allowIdfaReading = YES;
//    self.allowiAdInfoReading = YES;
//    _isSKAdNetworkHandlingActive = YES;
//
//    return self;
//}
//
//- (void)setLogLevel:(ADJLogLevel)logLevel {
//    [self setLogLevel:logLevel environment:self.environment];
//}
//
//- (void)setLogLevel:(ADJLogLevel)logLevel
//        environment:(NSString *)environment
//{
//    [self.logger setLogLevel:logLevel
//     isProductionEnvironment:[ADJEnvironmentProduction isEqualToString:environment]];
//}
//
//- (void)deactivateSKAdNetworkHandling {
//    _isSKAdNetworkHandlingActive = NO;
//}
//
//- (void)setDelegate:(NSObject<AdjustDelegate> *)delegate {
//    BOOL hasResponseDelegate = NO;
//    BOOL implementsDeeplinkCallback = NO;
//
//    if ([ADJUtil isNull:delegate]) {
//        [self.logger warn:@"Delegate is nil"];
//        _delegate = nil;
//        return;
//    }
//
//    if ([delegate respondsToSelector:@selector(adjustAttributionChanged:)]) {
//        [self.logger debug:@"Delegate implements adjustAttributionChanged:"];
//
//        hasResponseDelegate = YES;
//    }
//
//    if ([delegate respondsToSelector:@selector(adjustEventTrackingSucceeded:)]) {
//        [self.logger debug:@"Delegate implements adjustEventTrackingSucceeded:"];
//
//        hasResponseDelegate = YES;
//    }
//
//    if ([delegate respondsToSelector:@selector(adjustEventTrackingFailed:)]) {
//        [self.logger debug:@"Delegate implements adjustEventTrackingFailed:"];
//
//        hasResponseDelegate = YES;
//    }
//
//    if ([delegate respondsToSelector:@selector(adjustSessionTrackingSucceeded:)]) {
//        [self.logger debug:@"Delegate implements adjustSessionTrackingSucceeded:"];
//
//        hasResponseDelegate = YES;
//    }
//
//    if ([delegate respondsToSelector:@selector(adjustSessionTrackingFailed:)]) {
//        [self.logger debug:@"Delegate implements adjustSessionTrackingFailed:"];
//
//        hasResponseDelegate = YES;
//    }
//
//    if ([delegate respondsToSelector:@selector(adjustDeeplinkResponse:)]) {
//        [self.logger debug:@"Delegate implements adjustDeeplinkResponse:"];
//
//        // does not enable hasDelegate flag
//        implementsDeeplinkCallback = YES;
//    }
//
//    if (!(hasResponseDelegate || implementsDeeplinkCallback)) {
//        [self.logger error:@"Delegate does not implement any optional method"];
//        _delegate = nil;
//        return;
//    }
//
//    _delegate = delegate;
//}
//
//- (BOOL)checkEnvironment:(NSString *)environment
//{
//    if ([ADJUtil isNull:environment]) {
//        [self.logger error:@"Missing environment"];
//        return NO;
//    }
//    if ([environment isEqualToString:ADJEnvironmentSandbox]) {
//        [self.logger warnInProduction:@"SANDBOX: Adjust is running in Sandbox mode. Use this setting for testing. Don't forget to set the environment to `production` before publishing"];
//        return YES;
//    } else if ([environment isEqualToString:ADJEnvironmentProduction]) {
//        [self.logger warnInProduction:@"PRODUCTION: Adjust is running in Production mode. Use this setting only for the build that you want to publish. Set the environment to `sandbox` if you want to test your app!"];
//        return YES;
//    }
//    [self.logger error:@"Unknown environment '%@'", environment];
//    return NO;
//}
//
//- (BOOL)checkAppToken:(NSString *)appToken {
//    if ([ADJUtil isNull:appToken]) {
//        [self.logger error:@"Missing App Token"];
//        return NO;
//    }
//    if (appToken.length != 12) {
//        [self.logger error:@"Malformed App Token '%@'", appToken];
//        return NO;
//    }
//    return YES;
//}
//
//- (BOOL)isValid {
//    return self.appToken != nil;
//}
//
//- (void)setAppSecret:(NSUInteger)secretId
//               info1:(NSUInteger)info1
//               info2:(NSUInteger)info2
//               info3:(NSUInteger)info3
//               info4:(NSUInteger)info4 {
//    _secretId = [NSString stringWithFormat:@"%lu", (unsigned long)secretId];
//    _appSecret = [NSString stringWithFormat:@"%lu%lu%lu%lu",
//                   (unsigned long)info1,
//                   (unsigned long)info2,
//                   (unsigned long)info3,
//                   (unsigned long)info4];
//}


//- (nonnull id)copyWithZone:(nullable NSZone *)zone {
//    <#code#>
//}

@end
