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
#import "TikTokAppEventRequestHandler.h"
#import "TikTok.h"
#import "TikTokConfig.h"
#import "TikTokAppEventRequestHandler.h"

#define EVENT_NUMBER_THRESHOLD 100
#define EVENT_BATCH_REQUEST_THRESHOLD 1000
#define FLUSH_PERIOD_IN_SECONDS 15

@implementation TikTokAppEventQueue

- (id)init {
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
    
    self.timeInSecondsUntilFlush = FLUSH_PERIOD_IN_SECONDS;
    self.logTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *time) {
        
        NSDate *fireDate = [self.flushTimer fireDate];
        NSDate *nowDate = [NSDate date];
        self.timeInSecondsUntilFlush = [fireDate timeIntervalSinceDate:nowDate];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timeLeft" object:nil];
    }];
    
    self.config = config;
        
    self.requestHandler = [[TikTokAppEventRequestHandler alloc] init];
    
    [self calculateAndSetRemainingEventThreshold];
        
    return self;
}

- (void)addEvent:(TikTokAppEvent *)event {
    [self.eventQueue addObject:event];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"inMemoryEventQueueUpdated" object:nil];
    if(self.eventQueue.count > EVENT_NUMBER_THRESHOLD) {
        [self flush:TikTokAppEventsFlushReasonEventThreshold];
    }
    [self calculateAndSetRemainingEventThreshold];
}

- (void)flush:(TikTokAppEventsFlushReason)flushReason {
    @synchronized (self) {
        [[[TikTok getInstance] logger] info:@"Start flush, with flush reason: %lu current queue count: %lu", flushReason, self.eventQueue.count];
        NSArray *eventsFromDisk = [TikTokAppEventStore retrievePersistedAppEvents];
        [TikTokAppEventStore clearPersistedAppEvents];
        [[[TikTok getInstance] logger] info:@"Number events from disk: %lu", eventsFromDisk.count];
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
}

- (void)flushOnMainQueue:(NSMutableArray *)eventsToBeFlushed
               forReason:(TikTokAppEventsFlushReason)flushReason {
    [[[TikTok getInstance] logger] info:@"Total number events to be flushed: %lu", eventsToBeFlushed.count];
    
    if(eventsToBeFlushed.count > 0){
        if([[TikTok getInstance] isTrackingEnabled]) {
            // chunk eventsToBeFlushed into subarrays of EVENT_BATCH_REQUEST_THRESHOLD length or less and send requests for each
            NSMutableArray *eventChunks = [[NSMutableArray alloc] init];
            NSUInteger eventsRemaining = eventsToBeFlushed.count;
            int minIndex = 0;
            
            while(eventsRemaining > 0) {
                NSRange range = NSMakeRange(minIndex, MIN(EVENT_BATCH_REQUEST_THRESHOLD, eventsRemaining));
                NSArray *eventChunk = [eventsToBeFlushed subarrayWithRange:range];
                [eventChunks addObject:eventChunk];
                eventsRemaining -= range.length;
                minIndex += range.length;
            }
            
            for (NSArray *eventChunk in eventChunks) {
                [self.requestHandler sendPOSTRequest:eventChunk withConfig:self.config];
            }
        } else {
            [TikTokAppEventStore persistAppEvents:eventsToBeFlushed];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"inDiskEventQueueUpdated" object:nil];
        }
    }
    [[[TikTok getInstance] logger] info:@"End flush, current queue count: %lu", self.eventQueue.count];
}

- (void)calculateAndSetRemainingEventThreshold {
    
    if(self.eventQueue.count == 0) {
        self.remainingEventsUntilFlushThreshold = EVENT_NUMBER_THRESHOLD;
    } else {
        self.remainingEventsUntilFlushThreshold = EVENT_NUMBER_THRESHOLD - (int)self.eventQueue.count - 1;
    }
    
}

@end
