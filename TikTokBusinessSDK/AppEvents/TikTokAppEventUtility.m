//
//  TikTokAppEventUtility.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/10/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokAppEventUtility.h"

@implementation TikTokAppEventUtility

+ (dispatch_source_t)startTimerWithInterval:(double)interval block:(dispatch_block_t)block {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, // source type
                                                     0, // handle
                                                     0, // mask
                                                     dispatch_get_main_queue()); // queue
    
    dispatch_source_set_timer(timer, // dispatch source
                              dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), // start
                              interval * NSEC_PER_SEC, // interval
                              0 * NSEC_PER_SEC); // leeway
    
    dispatch_source_set_event_handler(timer, block);
    
    dispatch_resume(timer);
    
    return timer;
}

+ (NSString *)getCurrentTimestampInISO8601 {
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *now = [NSDate date];
    return [dateFormatter stringFromDate:now];
}

@end
