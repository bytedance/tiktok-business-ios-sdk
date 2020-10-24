//
//  TikTokAppEvent.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokAppEvent.h"
#import "TikTokAppEventUtility.h"

#define TIKTOKSDK_EVENTNAME_KEY @"eventName"
#define TIKTOKSDK_TIMESTAMP_KEY @"timestamp"
#define TIKTOKSDK_PROPERTIES_KEY @"properties"

@implementation TikTokAppEvent

- (id)initWithEventName:(NSString *)eventName
{
    if (self == nil) {
        return nil;
    }
    
    return [self initWithEventName:eventName withProperties:@{}];
    
}

- (id)initWithEventName:(NSString *)eventName
         withProperties: (NSDictionary *)properties
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.eventName = eventName;
    self.timestamp = [TikTokAppEventUtility getCurrentTimestampInISO8601];
    self.properties = properties;
   
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TikTokAppEvent *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy->_eventName = [self.eventName copyWithZone:zone];
        copy->_timestamp = [self.timestamp copyWithZone:zone];
        copy.properties = [self.properties copyWithZone:zone];
    }
    
    return copy;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeObject:self.eventName forKey:TIKTOKSDK_EVENTNAME_KEY];
    [encoder encodeObject:self.timestamp forKey:TIKTOKSDK_TIMESTAMP_KEY];
    [encoder encodeObject:self.properties forKey:TIKTOKSDK_PROPERTIES_KEY];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    NSString *eventName = [decoder decodeObjectOfClass:[NSString class] forKey:TIKTOKSDK_EVENTNAME_KEY];
    NSString *timestamp = [decoder decodeObjectOfClass:[NSString class] forKey:TIKTOKSDK_TIMESTAMP_KEY];
    NSDictionary *properties = [decoder decodeObjectOfClass:[NSDictionary class] forKey:TIKTOKSDK_PROPERTIES_KEY];
    if(self = [self initWithEventName:eventName]) {
        self.eventName = eventName;
        self.timestamp = timestamp;
        self.properties = properties;
    }
    return self;
}

@end
