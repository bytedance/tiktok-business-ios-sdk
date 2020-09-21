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

+ (void)sendPOSTRequest:(NSArray *)eventsToBeFlushed {
    
    // format events into object[]
    NSMutableArray *batch = [[NSMutableArray alloc] init];
    for (TikTokAppEvent* event in eventsToBeFlushed) {
        NSError *errorPropertiesJSON;
        NSData *propertiesJSON = [NSJSONSerialization dataWithJSONObject:event.parameters
                                                                 options:0
                                                                   error:&errorPropertiesJSON];
        NSString *propertiesJSONString = [[NSString alloc] initWithData:propertiesJSON encoding:NSUTF8StringEncoding];
        NSDictionary *eventDict = @{
            @"type" : @"track",
            @"event": event.eventName,
            @"timestamp":event.timestamp,
            @"properties": propertiesJSONString,
        };
        [batch addObject:eventDict];
    }
    
    // TODO: Populate context object from config
    NSDictionary *app = @{
        @"name" : [NSNull null],
        @"namespace": [NSNull null],
        @"version": [NSNull null],
        @"build": [NSNull null],
    };
    
    // TODO: Populate context object from config
    NSDictionary *device = @{
        @"platform" : @"iOS",
        @"idfa": [NSNull null],
        @"idfv": [NSNull null],
    };
    
    // TODO: Populate context object from config
    NSDictionary *context = @{
        @"app": app,
        @"device": device,
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
        @"app_id" : @"1211123727",
        @"batch": batch,
        @"context": contextJSONString,
    };
    
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parametersDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *postDataJSONString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"postDataJSONString: %@", postDataJSONString);
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // TODO: Update URL to "https://ads.tiktok.com/open_api/2/app/batch/"
    [request setURL:[NSURL URLWithString:@"http://10.231.17.7:9335/open_api/2/app/batch/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // TODO: get access token from TikTok SDK initialization
    [request setValue:@"abcdabcdabcdabcd00509731ca2343bbecb2b846" forHTTPHeaderField:@"Access-Token"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
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
