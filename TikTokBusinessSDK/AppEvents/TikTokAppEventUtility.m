//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
//

#import "TikTokAppEventUtility.h"

@implementation TikTokAppEventUtility

+ (NSString *)getCurrentTimestampInISO8601
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *now = [NSDate date];
    return [dateFormatter stringFromDate:now];
}

@end
