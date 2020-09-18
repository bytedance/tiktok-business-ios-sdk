//
//  TikTokAppEventRequestHandler.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/17/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokAppEvent.h"
#import "TikTokAppEventRequestHandler.h"
#import "TikTokAppEventStore.h"

@implementation TikTokAppEventRequestHandler

+ (void)sendPOSTRequest:(NSMutableArray *)eventsToBeFlushed {
    
    // format events into object[]
    NSMutableArray *batch = [[NSMutableArray alloc] init];
    for (TikTokAppEvent* event in eventsToBeFlushed) {
        NSDictionary *eventDict = @{
            @"type" : @"track",
            @"event": event.eventName,
            @"timestamp":event.timestamp,
            @"properties": event.parameters,
        };
        [batch addObject:eventDict];
    }

    // TODO: Populate context object from config
    NSDictionary *context = @{
        @"ad" : [NSNull null],
        @"app": [NSNull null],
        @"device": [NSNull null],
        @"locale": [NSNull null],
        @"ip": [NSNull null],
        @"userAgent": [NSNull null],
    };
    
    NSError *errorContextJSON;
    NSData *contextJSON = [NSJSONSerialization dataWithJSONObject:context
                                                       options:0
                                                         error:&errorContextJSON];
    NSString *contextJSONString = [[NSString alloc] initWithData:contextJSON encoding:NSUTF8StringEncoding];
    NSLog(@"contextJSONString: %@", contextJSONString);

    NSDictionary *parametersDict = @{
        // TODO: Populate appID from config
        @"app_id" : @"123",
        @"batch": batch,
        @"context": contextJSONString,
    };
    
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parametersDict
    options:NSJSONWritingPrettyPrinted
      error:&error];
    NSString *postDataJSONString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"postData: %@", postData);
    NSLog(@"postDataJSONString: %@", postDataJSONString);
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];

    // TODO: Uncomment block below once API is available
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:@"https://ads.tiktok.com/open_api/v1.1"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    // TODO: get access token from TikTok SDK initialization
//    [request setValue:@"XX" forHTTPHeaderField:@"Access-Token"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:postData];
    
    // TODO: Remove get request block below once API is available
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://ads.tiktok.com/marketing-partners/api/partner/get"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        // handle basic connectivity issues
        if(error) {
            NSLog(@"error: %@", error);
            [TikTokAppEventStore persistAppEvents:eventsToBeFlushed];
            return;
        }

        // handle HTTP errors
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];

            if (statusCode != 200) {
                NSLog(@"dataTaskWithRequest HTTP status code: %lu", statusCode);
                [TikTokAppEventStore persistAppEvents:eventsToBeFlushed];
                return;
            }
        }

        NSString *requestResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"Request response: %@", requestResponse);

    }] resume];
}

@end
