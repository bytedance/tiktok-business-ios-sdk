//
//  TikTokAppEvent.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokAppEvent.h"

@implementation TikTokAppEvent

- (id)initWithEventName:(NSString *)eventName {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    self.eventName = eventName;

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TikTokAppEvent *copy = [[[self class] allocWithZone:zone] init];

    if (copy) {
        copy->_appID = [self.appID copyWithZone:zone];
        copy->_eventName = [self.eventName copyWithZone:zone];
        copy->_jsonParameters = [self.jsonParameters copyWithZone:zone];
        copy.parameters = [self.parameters copyWithZone:zone];
    }

    return copy;
}

@end
