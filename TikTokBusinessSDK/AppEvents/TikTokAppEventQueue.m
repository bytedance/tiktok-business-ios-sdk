//
//  TikTokAppEventQueue.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokAppEvent.h"
#import "TikTokAppEventQueue.h"

@implementation TikTokAppEventQueue

- (id)init {
    if (self == nil) return nil;
    self.eventQueue = [NSMutableArray array];
    
    return self;
}

- (void)addEvent:(TikTokAppEvent *)event {
    [self.eventQueue addObject:event];
}

- (void)flush:(NSString *)flushReason {
    @synchronized (self) {
        [self.eventQueue removeAllObjects];
    }
    // TODO: implement additional flush logic
}


@end
