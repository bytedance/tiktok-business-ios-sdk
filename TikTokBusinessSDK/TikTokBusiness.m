//
//  TikTokBusiness.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

/**
 * Import headers for Apple's App Tracking Transparency Requirements 
 * - Default: App Tracking Dialog is shown to the user
 * - Use suppressAppTrackingDialog flag while initializing TikTokConfig to disable IDFA collection
*/
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#import "TikTokBusiness.h"
#import "TikTokConfig.h"
#import "TikTokLogger.h"
#import "AppEvents/TikTokAppEvent.h"
#import "AppEvents/TikTokAppEventQueue.h"
#import "AppEvents/TikTokAppEventStore.h"
#import "TikTokPaymentObserver.h"
#import "TikTokFactory.h"
#import "TikTokErrorHandler.h"
#import "TikTokUserAgentCollector.h"
#import "TikTokSKAdNetworkSupport.h"
#import "UIDevice+TikTokAdditions.h"

@interface TikTokBusiness()

@property (nonatomic, weak) id<TikTokLogger> logger;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL trackingEnabled;
@property (nonatomic) BOOL automaticTrackingEnabled;
@property (nonatomic) BOOL installTrackingEnabled;
@property (nonatomic) BOOL launchTrackingEnabled;
@property (nonatomic) BOOL retentionTrackingEnabled;
@property (nonatomic) BOOL paymentTrackingEnabled;
@property (nonatomic) BOOL appTrackingDialogSuppressed;
@property (nonatomic) BOOL SKAdNetworkSupportEnabled;
@property (nonatomic) BOOL userAgentCollectionEnabled;
@property (nonatomic, strong, nullable) TikTokAppEventQueue *queue;
@property (nonatomic, strong, nullable) TikTokRequestHandler *requestHandler;
@property (nonatomic, strong, readwrite) dispatch_queue_t isolationQueue;
@property (nonatomic) NSString *accessToken;

@end


@implementation TikTokBusiness: NSObject

#pragma mark - Object Lifecycle Methods

static TikTokBusiness * defaultInstance = nil;
static dispatch_once_t onceToken = 0;

+ (id)getInstance
{
    dispatch_once(&onceToken, ^{
        defaultInstance = [[self alloc] init];
    });
    return defaultInstance;
}

+ (void)resetInstance
{
  if (onceToken) {
    onceToken = 0;
  }
}

- (id)init
{
    self = [super init];
    if(self == nil) {
        return nil;
    }
    
    self.isolationQueue = dispatch_queue_create([@"tiktokIsolationQueue" UTF8String], DISPATCH_QUEUE_SERIAL);
    self.queue = nil;
    self.requestHandler = nil;
    self.logger = [TikTokFactory getLogger];
    self.enabled = YES;
    self.trackingEnabled = YES;
    self.automaticTrackingEnabled = YES;
    self.installTrackingEnabled = YES;
    self.launchTrackingEnabled = YES;
    self.retentionTrackingEnabled = YES;
    self.paymentTrackingEnabled = YES;
    self.appTrackingDialogSuppressed = NO;
    self.SKAdNetworkSupportEnabled = YES;
    self.userAgentCollectionEnabled = YES;
    
    if (@available(iOS 14, *)) {
        if(ATTrackingManager.trackingAuthorizationStatus == ATTrackingManagerAuthorizationStatusAuthorized) {
            self.userTrackingEnabled = YES;
            [self.logger info:@"Tracking is enabled"];
        } else {
            self.userTrackingEnabled = NO;
            [self.logger info:@"Tracking is disabled"];
        }
    } else {
        // For previous versions, we can assume that IDFA can be collected
        self.userTrackingEnabled = YES;
    }

    return self;
}

#pragma mark - Public static methods

+ (void)initializeSdk:(TikTokConfig *)tiktokConfig
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] initializeSdk: tiktokConfig];
    }
}

+ (void)trackEvent:(NSString *)eventName
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] trackEvent:eventName];
    }
}

+ (void)trackEvent:(NSString *)eventName
    withProperties:(NSDictionary *)properties
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] trackEvent:eventName withProperties:properties];
    }
}

+ (void)setTrackingEnabled:(BOOL)enabled
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] setTrackingEnabled:enabled];
    }
}

+ (void)setCustomUserAgent:(NSString *)customUserAgent
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] setCustomUserAgent:customUserAgent];
    }
}

+ (void)updateAccessToken:(nonnull NSString *)accessToken
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] updateAccessToken:accessToken];
    }
}

+ (NSString *)idfa {
    @synchronized (self) {
        return [[TikTokBusiness getInstance] idfa];
    }
}

+ (BOOL)appInForeground
{
    @synchronized (self) {
        return [[TikTokBusiness getInstance] appInForeground];
    }
}

+ (BOOL)appInBackground
{
    @synchronized (self) {
        return [[TikTokBusiness getInstance] appInBackground];
    }
}

+ (BOOL)appIsInactive
{
    @synchronized (self) {
        return [[TikTokBusiness getInstance] appIsInactive];
    }
}

+ (BOOL)isTrackingEnabled
{
    @synchronized (self) {
        return [[TikTokBusiness getInstance] isTrackingEnabled];
    }
}

+ (BOOL)isUserTrackingEnabled
{
    @synchronized (self) {
        return [[TikTokBusiness getInstance] isUserTrackingEnabled];
    }
}

+ (void)requestTrackingAuthorizationWithCompletionHandler:(void (^_Nullable)(NSUInteger status))completion
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] requestTrackingAuthorizationWithCompletionHandler:completion];
    }
}

+ (TikTokAppEventQueue *)getQueue
{
    @synchronized (self) {
        return [[TikTokBusiness getInstance] queue];
    }
}

+ (long)getInMemoryEventCount
{
    @synchronized (self) {
        return [[[TikTokBusiness getInstance] queue] eventQueue].count;
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
        return [[[TikTokBusiness getInstance] queue] timeInSecondsUntilFlush];
    }
}

+ (long)getRemainingEventsUntilFlushThreshold
{
    @synchronized (self) {
        return [[[TikTokBusiness getInstance] queue] remainingEventsUntilFlushThreshold];
    }
}

- (void)initializeSdk:(TikTokConfig *)tiktokConfig
{
    if(self.queue != nil){
        [self.logger warn:@"TikTok SDK has been initialized already!"];
        return;
    }

    NSSetUncaughtExceptionHandler(handleUncaughtExceptionPointer);
    self.trackingEnabled = tiktokConfig.trackingEnabled;
    self.automaticTrackingEnabled = tiktokConfig.automaticTrackingEnabled;
    self.installTrackingEnabled = tiktokConfig.installTrackingEnabled;
    self.launchTrackingEnabled = tiktokConfig.launchTrackingEnabled;
    self.retentionTrackingEnabled = tiktokConfig.retentionTrackingEnabled;
    self.paymentTrackingEnabled = tiktokConfig.paymentTrackingEnabled;
    self.appTrackingDialogSuppressed = tiktokConfig.appTrackingDialogSuppressed;
    self.SKAdNetworkSupportEnabled = tiktokConfig.SKAdNetworkSupportEnabled;
    self.userAgentCollectionEnabled = tiktokConfig.userAgentCollectionEnabled;
    self.accessToken = tiktokConfig.accessToken;
    
    if(self.userAgentCollectionEnabled) {
        [self loadUserAgent];
    }

    self.requestHandler = [[TikTokRequestHandler alloc] init];
    self.queue = [[TikTokAppEventQueue alloc] initWithConfig:tiktokConfig];
    
    [self.requestHandler getRemoteSwitch:tiktokConfig withCompletionHandler:^(BOOL isRemoteSwitchOn) {
        self.isRemoteSwitchOn = isRemoteSwitchOn;
        if(self.isRemoteSwitchOn) {
            [self.logger info:@"Remote switch is on"];
            [self.logger info:@"TikTok SDK Initialized Successfully!"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL launchedBefore = [defaults boolForKey:@"tiktokLaunchedBefore"];
            BOOL logged2DRetention = [defaults boolForKey:@"tiktokLogged2DRetention"];
            // Setting this variable to limit recomputations for 2DRetention past second day
            BOOL past2DLimit = [defaults boolForKey:@"tiktokPast2DLimit"];
            NSDate *installDate = (NSDate *)[defaults objectForKey:@"tiktokInstallDate"];
            
            if(self.automaticTrackingEnabled) {
                
                // Enabled: Tracking, Auto Logging, Install Logging
                // Launched Before: False
                if(!launchedBefore && self.installTrackingEnabled) {
                    [self trackEvent:@"InstallApp"];
                    // SKAdNetwork Support for Install Tracking (works on iOS 14.0+)
                    if(self.SKAdNetworkSupportEnabled) {
                        [[TikTokSKAdNetworkSupport sharedInstance] registerAppForAdNetworkAttribution];
                    }
                    [self trackEvent:@"LaunchApp"];
                    NSDate *currentLaunch = [NSDate date];
                    [defaults setBool:YES forKey:@"tiktokLaunchedBefore"];
                    [defaults setObject:currentLaunch forKey:@"tiktokInstallDate"];
                    [defaults synchronize];
                }
                
                // Enabled: Tracking, Auto Logging, Launch Logging
                // Launched Before: True
                if (launchedBefore && self.launchTrackingEnabled) {
                    [self trackEvent:@"LaunchApp"];
                }
                

                // Enabled: Tracking, Auto Logging, 2DRetention Logging
                // Install Date: Available
                // 2D Limit has not been passed
                if(installDate && self.retentionTrackingEnabled) {
                    if(!past2DLimit){
                        NSDate *currentLaunch = [NSDate date];
                        NSDate *oneDayAgo = [currentLaunch dateByAddingTimeInterval:-1 * 24 * 60 * 60];
                        NSTimeInterval secondsBetween = [currentLaunch timeIntervalSinceDate:installDate];
                        int numberOfDays = secondsBetween / 86400;
                        if ([[NSCalendar currentCalendar] isDate:oneDayAgo inSameDayAsDate:installDate] && !logged2DRetention) {
                            [self trackEvent:@"2DRetention"];
                            [defaults setBool:YES forKey:@"tiktokLogged2DRetention"];
                            [defaults synchronize];
                        }
                        
                        if (numberOfDays > 2){
                            [defaults setBool:YES forKey:@"tiktokPast2DLimit"];
                            [defaults synchronize];
                        }
                    }
                }
                
                if(self.paymentTrackingEnabled){
                    [TikTokPaymentObserver startObservingTransactions];
                }
            }
            
            // Remove this later, based on where modal needs to be called to start tracking
            // This will be needed to be called before we can call a function to get IDFA
            if(!self.appTrackingDialogSuppressed) {
                [self requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {}];
            }
            
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            [defaultCenter addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
            [defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        } else {
            [self.logger info:@"Remote switch is off"];
            [self.queue.flushTimer invalidate];
            [self.queue.logTimer invalidate];
            self.queue.timeInSecondsUntilFlush = 0;
        }
    }];

}

- (void)trackEvent:(NSString *)eventName
{
    TikTokAppEvent *appEvent = [[TikTokAppEvent alloc] initWithEventName:eventName];
    [self.queue addEvent:appEvent];
    if([eventName isEqualToString:@"Purchase"]){
        [self.queue flush:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
    }
}

- (void)trackEvent:(NSString *)eventName
    withProperties: (NSDictionary *)properties
{
    TikTokAppEvent *appEvent = [[TikTokAppEvent alloc] initWithEventName:eventName withProperties:properties];
    [self.queue addEvent:appEvent];
    if([eventName isEqualToString:@"Purchase"]){
        [self.queue flush:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [TikTokAppEventStore persistAppEvents:self.queue.eventQueue];
    [self.queue.eventQueue removeAllObjects];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    // Enabled: Tracking, Auto Logging, 2DRetention Logging
    // Install Date: Available
    // 2D Limit has not been passed
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL logged2DRetention = [defaults boolForKey:@"tiktokLogged2DRetention"];
    // Setting this variable to limit recomputations for 2DRetention past second day
    BOOL past2DLimit = [defaults boolForKey:@"tiktokPast2DLimit"];
    NSDate *installDate = (NSDate *)[defaults objectForKey:@"tiktokInstallDate"];
    
    if(self.automaticTrackingEnabled && installDate && self.retentionTrackingEnabled && !past2DLimit) {
        if(!past2DLimit){
            NSDate *currentLaunch = [NSDate date];
            NSDate *oneDayAgo = [currentLaunch dateByAddingTimeInterval:-1 * 24 * 60 * 60];
            NSTimeInterval secondsBetween = [currentLaunch timeIntervalSinceDate:installDate];
            int numberOfDays = secondsBetween / 86400;
            if ([[NSCalendar currentCalendar] isDate:oneDayAgo inSameDayAsDate:installDate] && !logged2DRetention) {
                [self trackEvent:@"2DRetention"];
                [defaults setBool:YES forKey:@"tiktokLogged2DRetention"];
                [defaults setBool:YES forKey:@"tiktokPast2DLimit"];
                [defaults synchronize];
            }
            
            if (numberOfDays > 2){
                [defaults setBool:YES forKey:@"tiktokPast2DLimit"];
                [defaults synchronize];
            }
        }
    }
    
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
    if(trackingEnabled){
        [TikTokPaymentObserver startObservingTransactions];
    } else {
        [TikTokPaymentObserver stopObservingTransactions];
    }
}

- (void)setCustomUserAgent:(NSString *)customUserAgent
{
    [[TikTokUserAgentCollector singleton] setUserAgent:customUserAgent];
}

- (void)updateAccessToken:(nonnull NSString *)accessToken
{
    self.accessToken = accessToken;
}

- (BOOL)isTrackingEnabled
{
    return self.trackingEnabled;
}

- (BOOL)isUserTrackingEnabled
{
    return self.userTrackingEnabled;
}

- (void)loadUserAgent {
    dispatch_async(self.isolationQueue, ^(){
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[TikTokUserAgentCollector singleton] loadUserAgentWithCompletion:^(NSString * _Nullable userAgent) {
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}

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
