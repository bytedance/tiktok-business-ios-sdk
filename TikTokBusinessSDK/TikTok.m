//
//  TikTok.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//
#import "TikTok.h"
#import "TikTokConfig.h"
#import "UIDevice+TikTokAdditions.h"
#import "AppEvents/TikTokAppEvent.h"
#import "AppEvents/TikTokAppEventQueue.h"
#import "AppEvents/TikTokAppEventStore.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <TikTokPaymentObserver.h>

NSString * const TikTokEnvironmentSandbox = @"sandbox";
NSString * const TikTokEnvironmentProduction = @"production";

@interface TikTok()

//@property (nonatomic) BOOL trackingEnabled;
@property (nonatomic) BOOL automaticLoggingEnabled;
@property (nonatomic) BOOL installLoggingEnabled;
@property (nonatomic) BOOL launchLoggingEnabled;
@property (nonatomic) BOOL retentionLoggingEnabled;
@property (nonatomic) BOOL paymentLoggingEnabled;

@end


@implementation TikTok: NSObject

#pragma mark - Object Lifecycle Methods

static TikTok * defaultInstance = nil;
static dispatch_once_t onceToken = 0;

+ (id)getInstance
{
    dispatch_once(&onceToken, ^{
        defaultInstance = [[self alloc] init];
    });
    return defaultInstance;
}

- (id)init
{
    self = [super init];
    if(self == nil) {
        return nil;
    }
    
    self.queue = nil;
    self.logger = [[TikTokLogger alloc] init];
    self.trackingEnabled = YES;
    self.automaticLoggingEnabled = YES;
    self.installLoggingEnabled = YES;
    self.launchLoggingEnabled = YES;
    self.retentionLoggingEnabled = YES;
    self.paymentLoggingEnabled = YES;
    self.trackingEnabled = YES;
    
    if (@available(iOS 14, *)) {
        if(ATTrackingManager.trackingAuthorizationStatus == ATTrackingManagerAuthorizationStatusAuthorized) {
            self.userTrackingEnabled = YES;
            [self.logger info:@"Tracking is enabled"];
        } else {
            self.userTrackingEnabled = NO;
            [self.logger info:@"Tracking is disabled"];
        }
    } else {
        self.userTrackingEnabled = YES; // verify
        // Fallback on earlier versions
    }
    
    return self;
}

#pragma mark - Public static methods

+ (void)appDidLaunch:(TikTokConfig *)tiktokConfig
{
    @synchronized (self) {
        [[TikTok getInstance] appDidLaunch: tiktokConfig];
    }
}

+ (void)trackEvent:(TikTokAppEvent *)appEvent
{
    @synchronized (self) {
        [[TikTok getInstance] trackEvent:appEvent];
    }
}

+ (void)trackPurchase:(TikTokAppEvent *)appEvent
{
    @synchronized (self) {
        [[TikTok getInstance] trackPurchase:appEvent];
    }
}

+ (void)setTrackingEnabled:(BOOL)enabled
{
    @synchronized (self) {
        [[TikTok getInstance] setTrackingEnabled:enabled];
    }
}

+ (void)setUserTrackingEnabled:(BOOL)enabled
{
    @synchronized (self) {
        [[TikTok getInstance] setUserTrackingEnabled:enabled];
    }
}

+ (void)setAutomaticLoggingEnabled:(BOOL)enabled
{
    @synchronized (self) {
        [[TikTok getInstance] setAutomaticLoggingEnabled:enabled];
    }
}

+ (void)setInstallLoggingEnabled:(BOOL)enabled
{
    @synchronized (self) {
        [[TikTok getInstance] setInstallLoggingEnabled:enabled];
    }
}

+ (void)setLaunchLoggingEnabled:(BOOL)enabled
{
    @synchronized (self) {
        [[TikTok getInstance] setLaunchLoggingEnabled:enabled];
    }
}

+ (void)setRetentionLoggingEnabled:(BOOL)enabled
{
    @synchronized (self) {
        [[TikTok getInstance] setRetentionLoggingEnabled:enabled];
    }
}

+ (void)setPaymentLoggingEnabled:(BOOL)enabled
{
    @synchronized (self) {
        [[TikTok getInstance] setPaymentLoggingEnabled:enabled];
    }
}

//+ (BOOL) isEnabled
//{
//    @synchronized (self) {
//        return [[TikTok getInstance] isEnabled];
//    }
//}

+ (NSString *)idfa {
    @synchronized (self) {
        return [[TikTok getInstance] idfa];
    }
}

+ (BOOL)appInForeground
{
    @synchronized (self) {
        return [[TikTok getInstance] appInForeground];
    }
}

+ (BOOL)appInBackground
{
    @synchronized (self) {
        return [[TikTok getInstance] appInBackground];
    }
}

+ (BOOL)appIsInactive
{
    @synchronized (self) {
        return [[TikTok getInstance] appIsInactive];
    }
}

+ (BOOL)isTrackingEnabled
{
    @synchronized (self) {
        return [[TikTok getInstance] isTrackingEnabled];
    }
}

+ (BOOL)isUserTrackingEnabled
{
    @synchronized (self) {
        return [[TikTok getInstance] isUserTrackingEnabled];
    }
}

+ (void)requestTrackingAuthorizationWithCompletionHandler:(void (^_Nullable)(NSUInteger status))completion
{
    @synchronized (self) {
        [[TikTok getInstance] requestTrackingAuthorizationWithCompletionHandler:completion];
    }
}

+ (TikTokAppEventQueue *)getQueue
{
    @synchronized (self) {
        return [[TikTok getInstance] queue];
    }
}

+ (long)getInMemoryEventCount
{
    @synchronized (self) {
        return [[[TikTok getInstance] queue] eventQueue].count;
    }
}

+ (long)getInDiskEventCount
{
    @synchronized (self) {
        return [TikTokAppEventStore retrievePersistedAppEvents].count;
    }
}

+ (long)getTimeInSecondsUntilFlush
{
    @synchronized (self) {
        return [[[TikTok getInstance] queue] timeInSecondsUntilFlush];
    }
}

+ (long)getRemainingEventsUntilFlushThreshold
{
    @synchronized (self) {
        return [[[TikTok getInstance] queue] remainingEventsUntilFlushThreshold];
    }
}


- (void)appDidLaunch:(TikTokConfig *)tiktokConfig
{
    if(self.queue != nil){
        [self.logger warn:@"TikTok SDK has been initialized already!"];
        return;
    }
    
    
    self.queue = [[TikTokAppEventQueue alloc] initWithConfig:tiktokConfig];
    [self.logger info: @"TikTok Event Queue has been initialized!"];
    [self.logger info:@"TikTok SDK Initialized Successfully!"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL launchedBefore = [defaults boolForKey:@"tiktokLaunchedBefore"];
    NSDate *lastLaunched = (NSDate *)[defaults objectForKey:@"tiktokLastLaunchedDate"];
    NSDate *currentLaunch = [NSDate date];
    
        
    if(self.trackingEnabled){
        if(self.automaticLoggingEnabled) {
            if (launchedBefore && self.launchLoggingEnabled) {
                [self trackEvent: [[TikTokAppEvent alloc] initWithEventName:@"LAUNCH_APP"]];
            } else {
                if(!launchedBefore && self.installLoggingEnabled) {
                    [self trackEvent: [[TikTokAppEvent alloc] initWithEventName:@"INSTALL_APP"]];
                }
                [defaults setBool:YES forKey:@"tiktokLaunchedBefore"];
                [defaults synchronize];
            }
            
            if(lastLaunched && self.retentionLoggingEnabled) {
                NSTimeInterval secondsBetween = [currentLaunch timeIntervalSinceDate:lastLaunched];
                int numberOfDays = secondsBetween / 86400;
                if ((numberOfDays <= 2) && (numberOfDays >= 1)) {
                    [self trackEvent:[[TikTokAppEvent alloc] initWithEventName:@"RETENTION_2D"]];
                }
            } else {
                [defaults setObject:currentLaunch forKey:@"tiktokLastLaunchedDate"];
                [defaults synchronize];
            }
            
            if(self.paymentLoggingEnabled){
                // TODO: this needs to be checked on the test app!
//                [TikTokPaymentObserver startObservingTransactions];
            }
        }

     
        // Remove this later, based on where modal needs to be called to start tracking
        // This will be needed to be called before we can call a function to get IDFA
        if(!tiktokConfig.isSuppressed) {
            [self requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {}];
        }
    } else {
        [self.logger info:@"Tracking has not been enabled by the developer!"];
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)trackEvent:(TikTokAppEvent *)appEvent
{
    [self.queue addEvent:appEvent];
    [self.logger info:@"Queue count: %lu", self.queue.eventQueue.count];
}

- (void)trackPurchase:(TikTokAppEvent *)appEvent
{
    [self trackEvent:appEvent];
    [self.queue flush:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [TikTokAppEventStore persistAppEvents:self.queue.eventQueue];
    [self.queue.eventQueue removeAllObjects];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self.queue flush:TikTokAppEventsFlushReasonAppBecameActive];
}

- (nullable NSString *)idfa
{
    return [[TikTokDeviceInfo alloc] deviceIdForAdvertisers];
}

- (BOOL)appInForeground
{
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)appInBackground
{
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)appIsInactive
{
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setTrackingEnabled:(BOOL)trackingEnabled
{
    _trackingEnabled = trackingEnabled;
}

- (void)setUserTrackingEnabled:(BOOL)userTrackingEnabled
{
    _userTrackingEnabled = userTrackingEnabled;
}

- (BOOL)isTrackingEnabled
{
    return self.trackingEnabled;
}

- (BOOL)isUserTrackingEnabled
{
    return self.userTrackingEnabled;
}

//- (void)setEnabled:(BOOL)enabled
//{
//    self.enabled = enabled;
//}

//- (void)setAutomaticLoggingEnabled:(BOOL)enabled
//{
//    self.automaticLoggingEnabled = enabled;
//}
//
//- (void)setInstallLoggingEnabled:(BOOL)enabled
//{
//    self.installLoggingEnabled = enabled;
//}
//
//- (void)setLaunchLoggingEnabled:(BOOL)enabled
//{
//    self.launchLoggingEnabled = enabled;
//}
//
//- (void)setRetentionLoggingEnabled:(BOOL)enabled
//{
//    self.retentionLoggingEnabled = enabled;
//}
//
//- (void)setPaymentLoggingEnabled:(BOOL)enabled
//{
//    self.paymentLoggingEnabled = enabled;
//}

- (void) requestTrackingAuthorizationWithCompletionHandler:(void (^)(NSUInteger))completion
{
    [UIDevice.currentDevice requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status)
    {
        if (completion) {
            completion(status);
            if (@available(iOS 14, *)) {
                if(status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    self.userTrackingEnabled = YES;
                    [self.logger info:@"Tracking is enabled"];
                } else {
                    self.userTrackingEnabled = NO;
                    [self.logger info:@"Tracking is disabled"];
                }
            } else {
                // Fallback on earlier versions
            }
        }
        // Might want to add more code here, but not sure at the moment
    }];
}

@end
