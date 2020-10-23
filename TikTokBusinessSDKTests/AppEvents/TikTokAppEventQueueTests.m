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
#import "TikTokRequestHandler.h"

@interface TikTokAppEventQueue()

- (void)flushOnMainQueue:(NSMutableArray *)eventsToBeFlushed
               forReason:(TikTokAppEventsFlushReason)flushReason;
@end

@interface TikTokAppEventQueueTests : XCTestCase

@property (nonatomic, strong) TikTok *tiktokMock;
@property (nonatomic, strong) TikTokAppEventQueue *queue;

@end

@implementation TikTokAppEventQueueTests

- (void)setUp {
    [super setUp];
    TikTokConfig *config = [[TikTokConfig alloc] initWithAppToken:@"App Token" appID: @"123" suppressAppTrackingDialog:NO];
    [TikTok appDidLaunch:config];
    TikTok *tiktok = [TikTok getInstance];
    self.tiktokMock = OCMPartialMock(tiktok);
    OCMStub([self.tiktokMock isRemoteSwitchOn]).andReturn(YES);
    
    TikTokAppEventQueue *queue = [[TikTokAppEventQueue alloc] init];
    self.queue = OCMPartialMock(queue);
    
    TikTokRequestHandler *requestHandler = OCMClassMock([TikTokRequestHandler class]);
    OCMStub([self.tiktokMock requestHandler]).andReturn(requestHandler);
    
    XCTAssertTrue(self.queue.eventQueue.count == 0, @"Queue should be empty");
}

- (void)tearDown {
    [super tearDown];
    [TikTok resetInstance];
}

- (void)testAddEvent {
    TikTokAppEvent *event = [[TikTokAppEvent alloc] initWithEventName:@"LAUNCH_APP"];
    
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
    OCMVerify(never(), [[self.tiktokMock requestHandler] sendBatchRequest:[OCMArg any] withConfig:[OCMArg any]]);


    // add an event to queue
    TikTokAppEvent *event = [[TikTokAppEvent alloc] initWithEventName:@"LAUNCH_APP"];
    [self.queue addEvent:event];

    [self.queue flushOnMainQueue:self.queue.eventQueue forReason:TikTokAppEventsFlushReasonEagerlyFlushingEvent];

    // now expect sendBatchRequest to be called, since queue has an event
    OCMVerify([[self.tiktokMock requestHandler] sendBatchRequest:[OCMArg any] withConfig:[OCMArg any]]);

}

@end
