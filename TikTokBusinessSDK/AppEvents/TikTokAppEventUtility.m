//
//  TikTokAppEventUtility.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/10/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokAppEventUtility.h"

@implementation TikTokAppEventUtility

+ (NSString *)getCurrentTimestampInISO8601 {
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *now = [NSDate date];
    return [dateFormatter stringFromDate:now];
}

@end
