//
//  TikTok.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//
#import "TikTok.h"
#import "TikTokConfig.h"
#import "TikTokAppEvent.h"
#import "TikTokAppEventQueue.h"

NSString * const TikTokEnvironmentSandbox = @"sandbox";
NSString * const TikTokEnvironmentProduction = @"production";

@interface TikTok()

@property (nonatomic, weak) TikTokLogger *logger;
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
    NSLog(@"TikTok SDK Initialized");
    
    self.queue = nil;
    self.logger = [[TikTokLogger alloc] init];
    self.enabled = YES;
    
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


+ (NSString *)adid {
    @synchronized (self) {
        return [[TikTok getInstance] adid];
    }
}

//+ (void)requestTrackingAuthorizationWithCompletionHandler:(void (^_Nullable)(NSUInteger status))completion
//{
//    @synchronized (self) {
//        [[Adjust getInstance] requestTrackingAuthorizationWithCompletionHandler:completion];
//    }
//}

- (void)appDidLaunch:(TikTokConfig *)tiktokConfig
{
    if(self.queue != nil){
        [self.logger info:@"TikTok SDK has been initialized already!"];
        return;
    }
    
    
    self.queue = [[TikTokAppEventQueue alloc] init];
    [self.logger info: @"Event Queue has been initialized!"];
}

- (void)trackEvent:(TikTokAppEvent *)appEvent
{
    [self.queue addEvent:appEvent];
    NSLog(@"Queue count: %lu", self.queue.eventQueue.count);
}


@end




//
//#import "TikTok.h"
//#import "TikTokLogger.h"
//#import "TikTokAppEventQueue.h"
//
//@interface TikTok()
//
//@property (nonatomic, assign) BOOL testEnvironment;
//@property (nonatomic, strong) TikTokAppEventQueue *queue;
//
//@end
//
//@implementation TikTok
//
//static TikTok *defaultInstance = nil;
//static dispatch_once_t onceToken = 0;
//
//+ (id)getInstance
//{
//    dispatch_once(&onceToken, ^{
//        defaultInstance = [[self alloc] init];
//    });
//    return defaultInstance;
//}
//
//-(instancetype)init
//{
//    self = [super init];
//
//    if(self)
//    {
//        self.testEnvironment = @"PRODUCTION";
//        self.queue = [[TikTokAppEventQueue alloc] init];
//        NSLog(@"TikTok SDK initialized");
//        NSLog(@"Queue count: %lu", self.queue.eventQueue.count);
//    }
//
//    return self;
//}
//
//
//-(instancetype)initDuringTest:(BOOL)testEnvironment
//{
//    self = [super init];
//
//    if(self)
//    {
//        self.testEnvironment = testEnvironment;
//        self.queue = [[TikTokAppEventQueue alloc] init];
//        NSLog(@"TikTok SDK initialized");
//        NSLog(@"Queue count: %lu", self.queue.eventQueue.count);
//    }
//
//    return self;
//}
//
//- (void)trackEvent:(TikTokAppEvent *)event {
//    [self.queue addEvent:event];
//    NSLog(@"Queue count: %lu", self.queue.eventQueue.count);
//}
//
//@end
