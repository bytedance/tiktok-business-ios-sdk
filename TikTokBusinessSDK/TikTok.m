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
#import "AppEvents/TikTokAppEventUtility.h"

NSString * const TikTokEnvironmentSandbox = @"sandbox";
NSString * const TikTokEnvironmentProduction = @"production";

@interface TikTok()

@property (nonatomic, strong) TikTokLogger *logger;
@property (nonatomic, strong) TikTokAppEventQueue *queue;
@property (nonatomic) BOOL enabled;

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
    self.enabled = YES;
    [self.logger info:@"TikTok SDK Initialized Successfully!"];
    
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

+ (void)setEnabled:(BOOL)enabled
{
    @synchronized (self) {
        [[TikTok getInstance] setEnabled:enabled];
    }
}

+ (BOOL) isEnabled
{
    @synchronized (self) {
        return [[TikTok getInstance] isEnabled];
    }
}

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

+ (void)requestTrackingAuthorizationWithCompletionHandler:(void (^_Nullable)(NSUInteger status))completion
{
    @synchronized (self) {
        [[TikTok getInstance] requestTrackingAuthorizationWithCompletionHandler:completion];
    }
}

- (void)appDidLaunch:(TikTokConfig *)tiktokConfig
{
    if(self.queue != nil){
        [self.logger warn:@"TikTok SDK has been initialized already!"];
        return;
    }
    
    
    self.queue = [[TikTokAppEventQueue alloc] init];
    [self.logger info: @"TikTok Event Queue has been initialized!"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL launchedBefore = [defaults boolForKey:@"tiktokLaunchedBefore"];
    
    if (launchedBefore) {
        [self trackEvent: [[TikTokAppEvent alloc] initWithEventName:@"LAUNCH_APP"]];
    } else {
        [self trackEvent: [[TikTokAppEvent alloc] initWithEventName:@"INSTALL_APP"]];
        [defaults setBool:YES forKey:@"tiktokLaunchedBefore"];
        [defaults synchronize];
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void)trackEvent:(TikTokAppEvent *)appEvent
{
    [self.queue addEvent:appEvent];
    [self.logger info:@"Queue count: %lu", self.queue.eventQueue.count];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self.queue flush:TikTokAppEventsFlushReasonAppEnteredBackground];
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

- (void) requestTrackingAuthorizationWithCompletionHandler:(void (^)(NSUInteger))completion
{
    [UIDevice.currentDevice requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status)
    {
        if (completion) {
            completion(status);
            NSLog(@"%lu", status);
        }
        // Might want to add more code here, but not sure at the moment
    }];
}

@end
