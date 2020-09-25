//
//  TikTokAppEventUtility.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/10/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TikTokAppEventsFlushReason)
{
    TikTokAppEventsFlushReasonTimer,
    TikTokAppEventsFlushReasonEventThreshold,
    TikTokAppEventsFlushReasonEagerlyFlushingEvent,
    TikTokAppEventsFlushReasonAppEnteredBackground,
};

@interface TikTokAppEventUtility : NSObject

+ (NSString *)getCurrentTimestampInISO8601;

@end

NS_ASSUME_NONNULL_END
