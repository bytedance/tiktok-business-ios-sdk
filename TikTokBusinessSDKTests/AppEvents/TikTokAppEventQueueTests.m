//
//  TikTokAppEventQueueTests.m
//  TikTokBusinessSDKTests
//
//  Created by Christopher Yang on 10/2/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "TikTok.h"
#import "TikTokAppEvent.h"
#import "TikTokAppEventQueue.h"
#import "TikTokAppEventRequestHandler.h"

@interface TikTokAppEventQueue()

- (void)flushOnMainQueue:(NSMutableArray *)eventsToBeFlushed
               forReason:(TikTokAppEventsFlushReason)flushReason;
@end

@interface TikTokAppEventQueueTests : XCTestCase

@property (nonatomic, strong) TikTokAppEventQueue *queue;

@end

@implementation TikTokAppEventQueueTests

- (void)setUp {
    [super setUp];
    TikTokConfig *config = [[TikTokConfig alloc] initWithAppToken:@"App Token" suppressAppTrackingDialog:NO];
    [TikTok appDidLaunch:config];
    TikTok *tiktok = [TikTok getInstance];
    id partialMock = OCMPartialMock(tiktok);
    OCMStub([partialMock isRemoteSwitchOn]).andReturn(YES);
    
    self.queue = [[TikTokAppEventQueue alloc] init];
    XCTAssertTrue(self.queue.eventQueue.count == 0, @"Queue should be empty");
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAddEvent {
    TikTokAppEvent *event = [[TikTokAppEvent alloc] initWithEventName:@"LAUNCH_APP"];

    [self.queue addEvent:event];
    [self.queue addEvent:event];
    XCTAssertTrue(self.queue.eventQueue.count == 2, @"Queue should have length of 2");
}

- (void)testFlushOnMainQueue {

    // mock request handler to see if sendPOSTRequest will be invoked
    TikTokAppEventRequestHandler *requestHandler = OCMClassMock([TikTokAppEventRequestHandler class]);
    self.queue.requestHandler = requestHandler;

    [self.queue flushOnMainQueue:self.queue.eventQueue forReason:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
    
    // expect sendPOSTRequest to not be called, since queue currently has no events
    OCMVerify(never(), [requestHandler sendPOSTRequest:[OCMArg any] withConfig:[OCMArg any]]);
    
    // add an event to queue
    TikTokAppEvent *event = [[TikTokAppEvent alloc] initWithEventName:@"LAUNCH_APP"];
    [self.queue addEvent:event];
    
    [self.queue flushOnMainQueue:self.queue.eventQueue forReason:TikTokAppEventsFlushReasonEagerlyFlushingEvent];
    
    // now expect sendPOSTRequest to be called, since queue has an event
    OCMVerify([requestHandler sendPOSTRequest:[OCMArg any] withConfig:[OCMArg any]]);
}

@end
