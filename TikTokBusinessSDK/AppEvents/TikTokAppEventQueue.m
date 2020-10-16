//
//  TikTokAppEventQueue.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokAppEvent.h"
#import "TikTokAppEventQueue.h"
#import "TikTokAppEventStore.h"
#import "TikTokAppEventUtility.h"
#import "TikTok.h"
#import "TikTokConfig.h"
#import "TikTokLogger.h"
#import "TikTokFactory.h"
#import "TikTokErrorHandler.h"

#define FLUSH_LIMIT 100
#define API_LIMIT 50
#define FLUSH_PERIOD_IN_SECONDS 15

@interface TikTokAppEventQueue()

@property (nonatomic, weak) id<TikTokLogger> logger;

@end

@implementation TikTokAppEventQueue

- (id)init
{
    if (self == nil) return nil;
    
    return [self initWithConfig:nil];
}

- (id)initWithConfig:(TikTokConfig *)config
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.eventQueue = [NSMutableArray array];
    
    __weak TikTokAppEventQueue *weakSelf = self;
    self.flushTimer = [NSTimer scheduledTimerWithTimeInterval:FLUSH_PERIOD_IN_SECONDS repeats:YES block:^(NSTimer *timer) {
        [weakSelf flush:TikTokAppEventsFlushReasonTimer];
    }];
    
    self.logTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *time) {
        
        NSDate *fireDate = [self.flushTimer fireDate];
        NSDate *nowDate = [NSDate date];
        self.timeInSecondsUntilFlush = [fireDate timeIntervalSinceDate:nowDate];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timeLeft" object:nil];
    }];
    
    self.config = config;
    
    self.logger = [TikTokFactory getLogger];
    
    [self calculateAndSetRemainingEventThreshold];

    return self;
}

- (void)addEvent:(TikTokAppEvent *)event
{
    if([[TikTok getInstance] isRemoteSwitchOn] == NO) {
        [self.logger info:@"[TikTokAppEventQueue] Remote switch is off, no event added"];
        return;
    }
    [self.eventQueue addObject:event];
    if(self.eventQueue.count >= FLUSH_LIMIT) {
        [self flush:TikTokAppEventsFlushReasonEventThreshold];
    }
    [self calculateAndSetRemainingEventThreshold];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"inMemoryEventQueueUpdated" object:nil];
}

- (void)flush:(TikTokAppEventsFlushReason)flushReason
{
    if([[TikTok getInstance] isRemoteSwitchOn] == NO) {
        [self.logger info:@"[TikTokAppEventQueue] Remote switch is off, no flush logic invoked"];
        return;
    }
    
    @try {
        @synchronized (self) {
            [self.logger info:@"[TikTokAppEventQueue] Start flush, with flush reason: %lu current queue count: %lu", flushReason, self.eventQueue.count];
            NSArray *eventsFromDisk = [TikTokAppEventStore retrievePersistedAppEvents];
            [TikTokAppEventStore clearPersistedAppEvents];
            [self.logger info:@"[TikTokAppEventQueue] Number events from disk: %lu", eventsFromDisk.count];
            NSMutableArray *eventsToBeFlushed = [NSMutableArray arrayWithArray:eventsFromDisk];
            NSArray *copiedEventQueue = [self.eventQueue copy];
            [eventsToBeFlushed addObjectsFromArray:copiedEventQueue];
            [self.eventQueue removeAllObjects];
            [self calculateAndSetRemainingEventThreshold];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"inMemoryEventQueueUpdated" object:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self flushOnMainQueue:eventsToBeFlushed forReason:flushReason];
            });
        }
    } @catch (NSException *exception) {
        [TikTokErrorHandler handleErrorWithOrigin:NSStringFromClass([self class]) message:@"Failure on flush" exception:exception];
    }
}

- (void)flushOnMainQueue:(NSMutableArray *)eventsToBeFlushed
               forReason:(TikTokAppEventsFlushReason)flushReason
{
    @try {
        [self.logger info:@"[TikTokAppEventQueue] Total number events to be flushed: %lu", eventsToBeFlushed.count];
        if(eventsToBeFlushed.count > 0) {
            if([[TikTok getInstance] isTrackingEnabled]) {
                // chunk eventsToBeFlushed into subarrays of API_LIMIT length or less and send requests for each
                NSMutableArray *eventChunks = [[NSMutableArray alloc] init];
                NSUInteger eventsRemaining = eventsToBeFlushed.count;
                int minIndex = 0;
                
                while(eventsRemaining > 0) {
                    NSRange range = NSMakeRange(minIndex, MIN(API_LIMIT, eventsRemaining));
                    NSArray *eventChunk = [eventsToBeFlushed subarrayWithRange:range];
                    [eventChunks addObject:eventChunk];
                    eventsRemaining -= range.length;
                    minIndex += range.length;
                }
                
                for (NSArray *eventChunk in eventChunks) {
                    [[[TikTok getInstance] requestHandler] sendPOSTRequest:eventChunk withConfig:self.config];
                }
            } else {
                [TikTokAppEventStore persistAppEvents:eventsToBeFlushed];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"inDiskEventQueueUpdated" object:nil];
            }
        }
        [self.logger info:@"[TikTokAppEventQueue] End flush, current queue count: %lu", self.eventQueue.count];
    } @catch (NSException *exception) {
        [TikTokErrorHandler handleErrorWithOrigin:NSStringFromClass([self class]) message:@"Failure on flushing main queue" exception:exception];
    }
}

- (void)calculateAndSetRemainingEventThreshold
{
    self.remainingEventsUntilFlushThreshold = FLUSH_LIMIT - (int)self.eventQueue.count;
}

@end
