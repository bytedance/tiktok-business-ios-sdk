//
//  TestTikTokEvent.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TestTikTokEvent.h"

@interface TestTikTokEvent()

@property (nonatomic, assign) NSString* eventName;
 
@end


@implementation TestTikTokEvent

- (instancetype)init
{
    self = [super init];
    if (self == nil) return nil;
    self.eventName = nil;
    return self;
}


- (instancetype)initWithName: (NSString *)eventName;
{
    
    self = [super init];
    if (self == nil) return nil;
    self.eventName = eventName;
    return self;
}

- (void)logEvent
{
    NSLog(@"Test event was logged with name: %@", self.eventName);
}

- (void)lolwut
{
    NSLog(@"Just trying to show something is super fishy here!");
}

@end
