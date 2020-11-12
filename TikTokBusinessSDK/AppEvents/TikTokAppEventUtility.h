//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
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
