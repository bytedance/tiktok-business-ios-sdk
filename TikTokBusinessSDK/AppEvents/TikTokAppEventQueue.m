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
#import "TikTokDeviceInfo.h"
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
    self.flushTimer = [NSTimer scheduledTimerWithTimeInterval:FLUSH_PERIOD_IN_SECONDS repeats:YES block:^(NSTimer *time) {
        [weakSelf flush:TikTokAppEventsFlushReasonTimer];
    }];
    
    self.config = config;
    
    self.requestHandler = [[TikTokAppEventRequestHandler alloc] init];
    
    return self;
}

- (void)addEvent:(TikTokAppEvent *)event {
    [self.eventQueue addObject:event];
    if(self.eventQueue.count > EVENT_NUMBER_THRESHOLD) {
        [self flush:TikTokAppEventsFlushReasonEventThreshold];
    }
}

- (void)flush:(TikTokAppEventsFlushReason)flushReason {
    NSLog(@"Start flush, with flush reason: %lu current queue count: %lu", flushReason, self.eventQueue.count);
    NSArray *eventsFromDisk = [TikTokAppEventStore retrievePersistedAppEvents];
    NSLog(@"Number events from disk: %lu", eventsFromDisk.count);
    NSMutableArray *eventsToBeFlushed = [NSMutableArray arrayWithArray:eventsFromDisk];
    [eventsToBeFlushed addObjectsFromArray:self.eventQueue];
    NSLog(@"Total number events to be flushed: %lu", eventsToBeFlushed.count);
    
    if(eventsToBeFlushed.count > 0){
        TikTokDeviceInfo *deviceInfo = [TikTokDeviceInfo deviceInfoWithSdkPrefix:@""];
        if(deviceInfo.trackingEnabled) {
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
        }
        [self.eventQueue removeAllObjects];
    }
    NSLog(@"End flush, current queue count: %lu", self.eventQueue.count);
}

@end
