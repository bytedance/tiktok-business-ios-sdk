//
//  TikTokAppEventQueue.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TikTokAppEvent.h"
#import "TikTokAppEventUtility.h"
#import "TikTokConfig.h"
#import "TikTokAppEventRequestHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface TikTokAppEventQueue : NSObject

/**
 * @brief Event queue as a mutable array
 */
@property (nonatomic, strong) NSMutableArray *eventQueue;

@property (nonatomic, strong) NSTimer *flushTimer;

@property (nonatomic, strong) NSTimer *logTimer;

@property (nonatomic) int timeInSecondsUntilFlush;

@property (nonatomic) int remainingEventsUntilFlushThreshold;

@property (nonatomic, strong, nullable) TikTokConfig *config;

@property (nonatomic, strong, nullable) TikTokAppEventRequestHandler *requestHandler;


- (id)init;

- (id)initWithConfig: (TikTokConfig * _Nullable)config;

/**
 * @brief Add event to queue
 */
- (void)addEvent:(TikTokAppEvent *)event;

/**
 * @brief Flush logic
 */
- (void)flush:(TikTokAppEventsFlushReason)flushReason;

@end

NS_ASSUME_NONNULL_END
