//
//  TikTok.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTok.h"
#import "TikTokLogger.h"
#import "TikTokAppEventQueue.h"

@interface TikTok()

@property (nonatomic, assign) BOOL testEnvironment;

@property (nonatomic, strong) TikTokAppEventQueue *queue;

@end

@implementation TikTok

-(instancetype)initDuringTest:(BOOL)testEnvironment
{
    self = [super init];
    
    if(self)
    {
        self.testEnvironment = testEnvironment;
        self.queue = [[TikTokAppEventQueue alloc] init];
        NSLog(@"TikTok SDK initialized");
        NSLog(@"Queue count: %lu", self.queue.eventQueue.count);
    }
    
    return self;
}

- (void)trackEvent:(TikTokAppEvent *)event {
    [self.queue addEvent:event];
    NSLog(@"Queue count: %lu", self.queue.eventQueue.count);
}

@end
