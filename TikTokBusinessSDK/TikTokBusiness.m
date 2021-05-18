//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
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
#import "TikTokIdentifyUtility.h"
#import "TikTokUserAgentCollector.h"
#import "TikTokSKAdNetworkSupport.h"
#import "UIDevice+TikTokAdditions.h"
#import "TikTokSKAdNetworkConversionConfiguration.h"

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
@property (nonatomic) BOOL isGlobalConfigFetched;
@property (nonatomic, strong, nullable) TikTokAppEventQueue *queue;
@property (nonatomic, strong, nullable) TikTokRequestHandler *requestHandler;
@property (nonatomic, strong, readwrite) dispatch_queue_t isolationQueue;

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

+ (void)identifyWithExternalID:(nullable NSString *)externalID
             phoneNumber:(nullable NSString *)phoneNumber
                       email:(nullable NSString *)email
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] identifyWithExternalID:externalID phoneNumber:phoneNumber email:email];
        
    }
}

+ (void)logout
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] logout];
    }
}

+ (void)explicitlyFlush
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] explicitlyFlush];
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
    if(self.queue != nil) {
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
    self.accessToken = tiktokConfig.accessToken;
    NSString *anonymousID = [TikTokIdentifyUtility getOrGenerateAnonymousID];
    self.anonymousID = anonymousID;
    
    [self loadUserAgent];

    self.requestHandler = [TikTokFactory getRequestHandler];
    self.queue = [[TikTokAppEventQueue alloc] initWithConfig:tiktokConfig];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"true" forKey:@"AreTimersOn"];
    
    [self getGlobalConfig:tiktokConfig isFirstInitialization:YES];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

// Internally used method for 2D-Retention
- (void)track2DRetention
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *installDate = (NSDate *)[defaults objectForKey:@"tiktokInstallDate"];
    BOOL logged2DRetention = [defaults boolForKey:@"tiktokLogged2DRetention"];
    // Setting this variable to limit recomputations for 2DRetention past second day
    BOOL past2DLimit = [defaults boolForKey:@"tiktokPast2DLimit"];
    if(!past2DLimit) {
        NSDate *currentLaunch = [NSDate date];
        NSDate *oneDayAgo = [currentLaunch dateByAddingTimeInterval:-1 * 24 * 60 * 60];
        NSTimeInterval secondsBetween = [currentLaunch timeIntervalSinceDate:installDate];
        int numberOfDays = secondsBetween / 86400;
        if ([[NSCalendar currentCalendar] isDate:oneDayAgo inSameDayAsDate:installDate] && !logged2DRetention) {
            [self trackEvent:@"2Dretention"];
            [defaults setBool:YES forKey:@"tiktokLogged2DRetention"];
            [defaults synchronize];
        }
        
        if (numberOfDays > 2) {
            [defaults setBool:YES forKey:@"tiktokPast2DLimit"];
            [defaults synchronize];
        }
    }
}

- (void)trackEvent:(NSString *)eventName
{
    TikTokAppEvent *appEvent = [[TikTokAppEvent alloc] initWithEventName:eventName];
    if(self.SKAdNetworkSupportEnabled) {
        [[TikTokSKAdNetworkSupport sharedInstance] matchEventToSKANConfig:eventName withValue:@"0"];
    }
    [self.queue addEvent:appEvent];
    if([eventName isEqualToString:@"Purchase"]) {
        [self.queue flush:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
    }
}

- (void)trackEvent:(NSString *)eventName
    withProperties: (NSDictionary *)properties
{
    TikTokAppEvent *appEvent = [[TikTokAppEvent alloc] initWithEventName:eventName withProperties:properties];
     
    if(self.SKAdNetworkSupportEnabled) {
        NSString *value = [properties objectForKey:@"value"];
        [[TikTokSKAdNetworkSupport sharedInstance] matchEventToSKANConfig:eventName withValue:value];
    }
    [self.queue addEvent:appEvent];
    if([eventName isEqualToString:@"Purchase"]) {
        [self.queue flush:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
    }
}

- (void)trackEvent:(NSString *)eventName
          withType:(NSString *)type
{
    TikTokAppEvent *appEvent = [[TikTokAppEvent alloc] initWithEventName:eventName withType:type];
    [self.queue addEvent:appEvent];
    if([eventName isEqualToString:@"Purchase"]) {
        [self.queue flush:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
    }
}


- (void)trackEventAndEagerlyFlush:(NSString *)eventName
{
    [self trackEvent:eventName];
    [self.queue flush:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
}

- (void)trackEventAndEagerlyFlush:(NSString *)eventName
       withProperties: (NSDictionary *)properties
{
    [self trackEvent:eventName withProperties:properties];
    [self.queue flush:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
}

- (void)trackEventAndEagerlyFlush:(NSString *)eventName
       withType:(NSString *)type
{
    [self trackEvent:eventName withType:type];
    [self.queue flush:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [TikTokAppEventStore persistAppEvents:self.queue.eventQueue];
    [self.queue.eventQueue removeAllObjects];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if(self.queue.config.initialFlushDelay && ![[preferences objectForKey:@"HasFirstFlushOccurred"]  isEqual: @"true"]) {
        // pause timer when entering background when first flush has not happened
        [preferences setObject:@"false" forKey:@"AreTimersOn"];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    // Enabled: Tracking, Auto Logging, 2DRetention Logging
    // Install Date: Available
    // 2D Limit has not been passed
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *installDate = (NSDate *)[defaults objectForKey:@"tiktokInstallDate"];
    
    if(self.automaticTrackingEnabled && installDate && self.retentionTrackingEnabled) {
        [self track2DRetention];
    }
    
    if ([[defaults objectForKey:@"HasBeenInitialized"]  isEqual: @"true"]) {
        [self getGlobalConfig:self.queue.config isFirstInitialization:NO];
    }
    
    if(self.queue.config.initialFlushDelay && ![[defaults objectForKey:@"HasFirstFlushOccurred"]  isEqual: @"true"]) {
        // if first flush has not occurred, resume timer without flushing
        [defaults setObject:@"true" forKey:@"AreTimersOn"];
    } else {
        // else flush when entering foreground
        [self.queue flush:TikTokAppEventsFlushReasonAppBecameActive];
    }

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
    if(trackingEnabled) {
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
    if(!self.isGlobalConfigFetched) {
        [self getGlobalConfig:self.queue.config isFirstInitialization:NO];
    }
}

- (void)identifyWithExternalID:(nullable NSString *)externalID
             phoneNumber:(nullable NSString *)phoneNumber
                       email:(nullable NSString *)email
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([[defaults objectForKey:@"IsIdentified"]  isEqual: @"true"]){
        [self.logger warn:@"TikTok SDK has already identified. If you want to switch to another user, please call the function TikTokBusinessSDK.logout()"];
        return;
    }
    
    [TikTokIdentifyUtility setUserInfoDefaultsWithExternalID:externalID phoneNumber:phoneNumber email:email origin:NSStringFromClass([self class])];
    [self trackEventAndEagerlyFlush:@"Identify" withType: @"identify"];
}

- (void)logout
{
    // clear old anonymousID and userInfo from NSUserDefaults
    [TikTokIdentifyUtility resetNSUserDefaults];
       
    NSString *anonymousID = [TikTokIdentifyUtility getOrGenerateAnonymousID];
    [[TikTokBusiness getInstance] setAnonymousID:anonymousID];
    [self.logger verbose:@"AnonymousID on logout: %@", self.anonymousID];
    [self.queue flush:TikTokAppEventsFlushReasonLogout];
}

- (void)explicitlyFlush
{
    [self.queue flush:TikTokAppEventsFlushReasonExplicitlyFlush];
}

- (BOOL)isTrackingEnabled
{
    return self.trackingEnabled;
}

- (BOOL)isUserTrackingEnabled
{
    return self.userTrackingEnabled;
}

- (void)getGlobalConfig:(TikTokConfig *)tiktokConfig
  isFirstInitialization: (BOOL)isFirstInitialization
{
    [self.requestHandler getRemoteSwitch:tiktokConfig withCompletionHandler:^(BOOL isRemoteSwitchOn, BOOL isGlobalConfigFetched) {
        self.isRemoteSwitchOn = isRemoteSwitchOn;
        self.isGlobalConfigFetched = isGlobalConfigFetched;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        if(!self.isRemoteSwitchOn) {
            [self.logger info:@"Remote switch is off"];
            [defaults setObject:@"false" forKey:@"AreTimersOn"];
            self.queue.timeInSecondsUntilFlush = 0;
            return;
        }
        
        [self.logger info:@"Remote switch is on"];
        
        // restart timers if they are off
        if ([[defaults objectForKey:@"AreTimersOn"]  isEqual: @"false"]) {
            [defaults setObject:@"true" forKey:@"AreTimersOn"];
        }
        
        // if SDK has not been initialized, we initialize it
        if(isFirstInitialization || ![[defaults objectForKey:@"HasBeenInitialized"]  isEqual: @"true"]) {

            [self.logger info:@"TikTok SDK Initialized Successfully!"];
            [defaults setObject:@"true" forKey:@"HasBeenInitialized"];
            BOOL launchedBefore = [defaults boolForKey:@"tiktokLaunchedBefore"];
            NSDate *installDate = (NSDate *)[defaults objectForKey:@"tiktokInstallDate"];

            // Enabled: Tracking, Auto Tracking, Install Tracking
            // Launched Before: False
            if(self.automaticTrackingEnabled && !launchedBefore && self.installTrackingEnabled){
                [self trackEvent:@"InstallApp"];
                // SKAdNetwork Support for Install Tracking (works on iOS 14.0+)
                if(self.SKAdNetworkSupportEnabled) {
                    [[TikTokSKAdNetworkSupport sharedInstance] registerAppForAdNetworkAttribution];
                }
                NSDate *currentLaunch = [NSDate date];
                [defaults setBool:YES forKey:@"tiktokLaunchedBefore"];
                [defaults setObject:currentLaunch forKey:@"tiktokInstallDate"];
                [defaults synchronize];
            }

            // Enabled: Tracking, Auto Tracking, Launch Logging
            if(self.automaticTrackingEnabled && self.launchTrackingEnabled){
                [self trackEvent:@"LaunchAPP"];
            }

            // Enabled: Auto Tracking, 2DRetention Tracking
            // Install Date: Available
            // 2D Limit has not been passed
            if(self.automaticTrackingEnabled && installDate && self.retentionTrackingEnabled){
                [self track2DRetention];
            }

            if(self.automaticTrackingEnabled && self.paymentTrackingEnabled){
                [TikTokPaymentObserver startObservingTransactions];
            }

            if(!self.automaticTrackingEnabled){
                [TikTokPaymentObserver stopObservingTransactions];
            }

            // Remove this later, based on where modal needs to be called to start tracking
            // This will be needed to be called before we can call a function to get IDFA
            if(!self.appTrackingDialogSuppressed) {
                [self requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {}];
            }
        }
    }];
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

- (void)requestTrackingAuthorizationWithCompletionHandler:(void (^)(NSUInteger))completion
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
    }];
}

-(void)logSKANConfig
{
    NSInteger currConversionValue = [TikTokSKAdNetworkSupport sharedInstance].currentConversionValue;
    NSLog(@"CURRENT CONVERSION VALUE %ld", currConversionValue);
    [[TikTokSKAdNetworkConversionConfiguration sharedInstance] logAllRules];
}

+ (void)logSKANConfig
{
    @synchronized (self) {
        [[TikTokBusiness getInstance] logSKANConfig];
    }
}

@end
