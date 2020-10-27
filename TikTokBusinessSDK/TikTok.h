//
//  TikTok.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokConfig.h"
#import "TikTokLogger.h"
#import "TikTokAppEventQueue.h"
#import "TikTokRequestHandler.h"
//#import "TikTokAttribution.h"
//#import "TikTokSubscription.h"

NS_ASSUME_NONNULL_BEGIN

//@interface TikTokTestOptions : NSObject
//
//@property (nonatomic, copy, nullable) NSString *baseUrl;
//@property (nonatomic, copy, nullable) NSString *gdprUrl;
//@property (nonatomic, copy, nullable) NSString *subscriptionUrl;
//@property (nonatomic, copy, nullable) NSString *extraPath;
//@property (nonatomic, copy, nullable) NSNumber *timerIntervalInMilliseconds;
//@property (nonatomic, copy, nullable) NSNumber *timerStartInMilliseconds;
//@property (nonatomic, copy, nullable) NSNumber *sessionIntervalInMilliseconds;
//@property (nonatomic, copy, nullable) NSNumber *subsessionIntervalInMilliseconds;
//@property (nonatomic, assign) BOOL teardown;
//@property (nonatomic, assign) BOOL deleteState;
//@property (nonatomic, assign) BOOL noBackoffWait;
//@property (nonatomic, assign) BOOL iAdFrameworkEnabled;
//@property (nonatomic, assign) BOOL enableSigning;
//@property (nonatomic, assign) BOOL disableSigning;
//
//@end

/*
    Constants for supported tracking environments
 */
extern NSString * __nonnull const TikTokEnvironmentSandbox;
extern NSString * __nonnull const TikTokEnvironmentProduction;


@interface TikTok : NSObject

@property (nonatomic, weak) id<TikTokLogger> logger;
@property (nonatomic) BOOL trackingEnabled;
@property (nonatomic) BOOL userTrackingEnabled;
@property (nonatomic) BOOL isRemoteSwitchOn;
@property (nonatomic, strong, nullable) TikTokAppEventQueue *queue;
@property (nonatomic, strong, nullable) TikTokRequestHandler *requestHandler;
@property (nonatomic) NSString *accessToken;

//+ (id<TikTokLogger>)getLogger;
+ (void)appDidLaunch: (nullable TikTokConfig *)tiktokConfig;
+ (void)trackEvent: (NSString *)eventName;
+ (void)trackEvent: (NSString *)eventName
    withProperties: (NSDictionary *)properties;
+ (void)trackPurchase: (NSString *)eventName;
+ (void)trackPurchase: (NSString *)eventName
    withProperties: (NSDictionary *)properties;
//+ (void)trackSubsessionStart;
//+ (void)trackSubsessionEnd;
+ (void)setTrackingEnabled: (BOOL)enabled;
//+ (void)setUserTrackingEnabled: (BOOL)enabled;
+ (void)setAutomaticLoggingEnabled: (BOOL)enabled;
+ (void)setInstallLoggingEnabled: (BOOL)enabled;
+ (void)setLaunchLoggingEnabled: (BOOL)enabled;
+ (void)setRetentionLoggingEnabled: (BOOL)enabled;
+ (void)setPaymentLoggingEnabled: (BOOL)enabled;
+ (void)updateAccessToken: (nonnull NSString *)accessToken;
//+ (BOOL)isEnabled;
+ (BOOL)isTrackingEnabled;
+ (BOOL)isUserTrackingEnabled;
+ (TikTokAppEventQueue *)getQueue;
+ (long)getInMemoryEventCount;
+ (long)getInDiskEventCount;
+ (long)getTimeInSecondsUntilFlush;
+ (long)getRemainingEventsUntilFlushThreshold;
//+ (void)appWillOpenUrl:(nonnull NSURL *)url;
//+ (void)setDeviceToken:(nonnull NSData *)deviceToken;
//+ (void)setPushToken:(nonnull NSString *)pushToken;
//+ (void)setOfflineMode:(BOOL)enabled;
+ (nullable NSString *)idfa;
+ (BOOL)appInForeground;
+ (BOOL)appInBackground;
+ (BOOL)appIsInactive;
//+ (nullable ADJAttribution *)attribution;
//+ (nullable NSString *)sdkVersion;
//+ (void)sendFirstPackages;
//+ (void)sendAdWordsRequest;
//+ (void)addSessionCallbackParameter:(nonnull NSString *)key value:(nonnull NSString *)value;
//+ (void)addSessionPartnerParameter:(nonnull NSString *)key value:(nonnull NSString *)value;
//+ (void)removeSessionCallbackParameter:(nonnull NSString *)key;
//+ (void)removeSessionPartnerParameter:(nonnull NSString *)key;
//+ (void)resetSessionCallbackParameters;
//+ (void)resetSessionPartnerParameters;
//+ (void)gdprForgetMe;
//+ (void)trackAdRevenue:(nonnull NSString *)source payload:(nonnull NSData *)payload;
//+ (void)disableThirdPartySharing;
//+ (void)trackSubscription:(nonnull ADJSubscription *)subscription;
+ (void)requestTrackingAuthorizationWithCompletionHandler:(void (^_Nullable)(NSUInteger status))completion;
+ (nullable id)getInstance;
+ (void)resetInstance;
//- (id<TikTokLogger>)getLogger;
- (void)appDidLaunch:(nullable TikTokConfig *)tiktokConfig;
//+ (void)setTestOptions:(nullable TikTokTestOptions *)testOptions;
- (void)trackEvent: (NSString *)eventName;
- (void)trackEvent: (NSString *)eventName
    withProperties: (NSDictionary *)properties;
- (void)trackPurchase: (NSString *)eventName;
- (void)trackPurchase: (NSString *)eventName
    withProperties: (NSDictionary *)properties;
//- (void)setEnabled:(BOOL)enabled;
- (void)setAutomaticLoggingEnabled: (BOOL)enabled;
- (void)setInstallLoggingEnabled: (BOOL)enabled;
- (void)setLaunchLoggingEnabled: (BOOL)enabled;
- (void)setRetentionLoggingEnabled: (BOOL)enabled;
- (void)setPaymentLoggingEnabled: (BOOL)enabled;
- (void)updateAccessToken: (nonnull NSString *)accessToken;
- (BOOL)appInForeground;
- (BOOL)appInBackground;
- (BOOL)appIsInactive;
//- (void)teardown; // ??
//- (void)appWillOpenUrl:(nonnull NSURL *)url;
//
//- (void)setOfflineMode:(BOOL)enabled;
//
//- (void)setDeviceToken:(nonnull NSData *)deviceToken;
//
//- (void)setPushToken:(nonnull NSString *)pushToken;
//
//- (void)sendFirstPackages;
//
//- (void)trackSubsessionEnd;
//
//- (void)trackSubsessionStart;
//
//- (void)resetSessionPartnerParameters;
//
//- (void)resetSessionCallbackParameters;
//
//- (void)removeSessionPartnerParameter:(nonnull NSString *)key;
//
//- (void)removeSessionCallbackParameter:(nonnull NSString *)key;
//
//- (void)addSessionPartnerParameter:(nonnull NSString *)key value:(nonnull NSString *)value;
//
//- (void)addSessionCallbackParameter:(nonnull NSString *)key value:(nonnull NSString *)value;
//- (void)gdprForgetMe;
//
//- (void)trackAdRevenue:(nonnull NSString *)source payload:(nonnull NSData *)payload;
//
//- (void)trackSubscription:(nonnull ADJSubscription *)subscription;
//- (BOOL)isEnabled;
- (nullable NSString *)idfa;
//- (nullable ADJAttribution *)attribution;
//
//- (nullable NSURL *)convertUniversalLink:(nonnull NSURL *)url scheme:(nonnull NSString *)scheme;
- (void)requestTrackingAuthorizationWithCompletionHandler:(void (^_Nullable)(NSUInteger status))completion;
@end

NS_ASSUME_NONNULL_END


//#import <Foundation/Foundation.h>
//#import "TikTokLogger.h"
//#import "TikTokAppEventQueue.h"
//#import "TikTokAppEvent.h"
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface TikTok : NSObject
//
//+ (id)sharedInstance;
//- (id)init;
//- (id)initDuringTest: (BOOL) testEnvironment;
//
//- (void)trackEvent:(nullable TikTokAppEvent *)event;
//
//@end
//
