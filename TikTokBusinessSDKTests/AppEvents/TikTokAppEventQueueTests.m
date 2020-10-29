//
//  TikTokAppEventQueueTests.m
//  TikTokBusinessSDKTests
//
//  Created by Christopher Yang on 10/2/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "TikTokBusiness.h"
#import "TikTokAppEvent.h"
#import "TikTokAppEventQueue.h"
#import "TikTokRequestHandler.h"

@interface TikTokAppEventQueue()

- (void)flushOnMainQueue:(NSMutableArray *)eventsToBeFlushed
               forReason:(TikTokAppEventsFlushReason)flushReason;
@end

@interface TikTokAppEventQueueTests : XCTestCase

@property (nonatomic, strong) TikTokBusiness *tiktokBusiness;
@property (nonatomic, strong) TikTokAppEventQueue *queue;

@end

@implementation TikTokAppEventQueueTests

- (void)setUp {
    [super setUp];
    TikTokConfig *config = [[TikTokConfig alloc] initWithAccessToken:@"ACCESS_TOKEN" appID: @"123" suppressAppTrackingDialog:NO];
    [TikTokBusiness initializeSdk:config];
    TikTokBusiness *tiktokBusiness = [TikTokBusiness getInstance];
    self.tiktokBusiness = OCMPartialMock(tiktokBusiness);
    OCMStub([self.tiktokBusiness isRemoteSwitchOn]).andReturn(YES);
    
    TikTokAppEventQueue *queue = [[TikTokAppEventQueue alloc] init];
    self.queue = OCMPartialMock(queue);
    
    TikTokRequestHandler *requestHandler = OCMClassMock([TikTokRequestHandler class]);
    OCMStub([self.tiktokBusiness requestHandler]).andReturn(requestHandler);
    
    XCTAssertTrue(self.queue.eventQueue.count == 0, @"Queue should be empty");
}

- (void)tearDown {
    [super tearDown];
    [TikTokBusiness resetInstance];
}

- (void)testAddEvent {
    TikTokAppEvent *event = [[TikTokAppEvent alloc] initWithEventName:@"LaunchApp"];
    
    for (int i = 0; i < 99; i++)
    {
        [self.queue addEvent:event];
    }
    
    XCTAssertTrue(self.queue.eventQueue.count == 99, @"Queue should have length of 99");
    
    [self.queue addEvent:event];
    
    // expect events to flush after 100 events added to queue
    OCMVerify([self.queue flush:TikTokAppEventsFlushReasonEventThreshold]);
}

- (void)testFlushOnMainQueue {

    [self.queue flushOnMainQueue:self.queue.eventQueue forReason:TikTokAppEventsFlushReasonEagerlyFlushingEvent];

    // expect sendBatchRequest to not be called, since queue currently has no events
    OCMVerify(never(), [[self.tiktokBusiness requestHandler] sendBatchRequest:[OCMArg any] withConfig:[OCMArg any]]);


    // add an event to queue
    TikTokAppEvent *event = [[TikTokAppEvent alloc] initWithEventName:@"LaunchApp"];
    [self.queue addEvent:event];

    [self.queue flushOnMainQueue:self.queue.eventQueue forReason:TikTokAppEventsFlushReasonEagerlyFlushingEvent];

    // now expect sendBatchRequest to be called, since queue has an event
    OCMVerify([[self.tiktokBusiness requestHandler] sendBatchRequest:[OCMArg any] withConfig:[OCMArg any]]);

}

@end
