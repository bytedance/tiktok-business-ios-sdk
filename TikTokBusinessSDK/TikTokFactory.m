//
//  TikTokFactory.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 10/9/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokFactory.h"

static id<TikTokLogger> internalLogger = nil;

@implementation TikTokFactory

+ (id<TikTokLogger>)getLogger
{
    if (internalLogger == nil) {
        internalLogger = [[TikTokLogger alloc] init];
    }
    return internalLogger;
}

+ (void)setLogger:(id<TikTokLogger>)logger
{
    internalLogger = logger;
}

@end
