//
//  TikTokAppEventUtility.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/10/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief Enum for flush reasoning
 */
typedef NS_ENUM(NSUInteger, TikTokAppEventsFlushReason)
{
    TikTokAppEventsFlushReasonTimer,
    TikTokAppEventsFlushReasonEventThreshold,
    TikTokAppEventsFlushReasonEagerlyFlushingEvent,
    TikTokAppEventsFlushReasonAppBecameActive,
};

@interface TikTokAppEventUtility : NSObject

/**
 * @brief Method to obtain timestamp in ISO8601
 */
+ (NSString *)getCurrentTimestampInISO8601;

@end

NS_ASSUME_NONNULL_END
