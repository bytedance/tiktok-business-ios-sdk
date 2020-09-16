//
//  TikTokAppEvent.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokAppEvent.h"

#define TIKTOKSDK_APPID_KEY @"appID"
#define TIKTOKSDK_EVENTNAME_KEY @"eventName"
#define TIKTOKSDK_TIMESTAMP_KEY @"timestamp"
#define TIKTOKSDK_PARAMETERS_KEY @"parameters"

@implementation TikTokAppEvent

- (id)initWithEventName:(NSString *)eventName {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.eventName = eventName;
    NSTimeInterval timeStamp = round([[NSDate date] timeIntervalSince1970]);
    self.timestamp = [NSNumber numberWithDouble: timeStamp];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TikTokAppEvent *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy->_appID = [self.appID copyWithZone:zone];
        copy->_eventName = [self.eventName copyWithZone:zone];
        copy->_timestamp = [self.timestamp copyWithZone:zone];
        copy.parameters = [self.parameters copyWithZone:zone];
    }
    
    return copy;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeObject:self.appID forKey:TIKTOKSDK_APPID_KEY];
    [encoder encodeObject:self.eventName forKey:TIKTOKSDK_EVENTNAME_KEY];
    [encoder encodeObject:self.timestamp forKey:TIKTOKSDK_TIMESTAMP_KEY];
    [encoder encodeObject:self.parameters forKey:TIKTOKSDK_PARAMETERS_KEY];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    NSString *appID = [decoder decodeObjectOfClass:[NSString class] forKey:TIKTOKSDK_APPID_KEY];
    NSString *eventName = [decoder decodeObjectOfClass:[NSString class] forKey:TIKTOKSDK_EVENTNAME_KEY];
    NSNumber *timestamp = [decoder decodeObjectOfClass:[NSNumber class] forKey:TIKTOKSDK_TIMESTAMP_KEY];
    NSDictionary *parameters = [decoder decodeObjectOfClass:[NSDictionary class] forKey:TIKTOKSDK_PARAMETERS_KEY];
    if(self = [self initWithEventName:eventName]) {
        self.appID = appID;
        self.eventName = eventName;
        self.timestamp = timestamp;
        self.parameters = parameters;
    }
    return self;
}

@end
