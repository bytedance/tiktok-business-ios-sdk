//
//  TikTokAppEventQueue.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TikTokAppEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface TikTokAppEventQueue : NSObject

/**
 * @brief Event queue as a mutable array
 */
@property (nonatomic, strong) NSMutableArray *eventQueue;

@property (nonatomic, strong) dispatch_source_t flushTimer;

- (id)init;

/**
 * @brief Add event to queue
 */
- (void)addEvent:(TikTokAppEvent *)event;

/**
 * @brief Flush logic
 */
- (void)flush:(NSString *)flushReason;

@end

NS_ASSUME_NONNULL_END
