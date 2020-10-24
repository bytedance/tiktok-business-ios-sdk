//
//  TikTokAppEventTests.m
//  TikTokBusinessSDKTests
//
//  Created by Christopher Yang on 10/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TikTokAppEvent.h"

@interface TikTokAppEventTests : XCTestCase

@end

@implementation TikTokAppEventTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
    NSString *eventName = @"TEST_EVENT_NAME";
    
    TikTokAppEvent *event = [[TikTokAppEvent alloc] initWithEventName:eventName];
    
    XCTAssertTrue(eventName == event.eventName, @"Event should initialize correctly with event name");
    
    XCTAssertTrue(event.properties.count == 0, @"Event should not have any properties");
}

- (void)testInitWithProperties{
    NSString *eventName = @"TEST_EVENT_NAME";
    NSDictionary *properties = @{
        @"key_1":@"value_1",
        @"key_2":@"value_2"
    };
    
    TikTokAppEvent *event = [[TikTokAppEvent alloc] initWithEventName:eventName withProperties:properties];
    
    XCTAssertTrue(eventName == event.eventName, @"Event should initialize correctly with event name");
    
    XCTAssertTrue(event.properties.count == 2, @"Event should have 2 properties");
}

@end
