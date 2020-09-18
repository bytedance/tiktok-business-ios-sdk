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
        NSMutableDictionary *eventDict=[[NSMutableDictionary alloc] init];
        [eventDict setValue:@"track" forKey:@"type"];
        [eventDict setValue:event.eventName forKey:@"event"];
        [eventDict setValue:event.timestamp forKey:@"timestamp"];
        [eventDict setValue:event.parameters forKey:@"properties"];
    }
    
    // TODO: Populate context object from config
    // context object
    NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
    [context setValue:nil forKey:@"ad"];
    [context setValue:nil forKey:@"app"];
    [context setValue:nil forKey:@"device"];
    [context setValue:nil forKey:@"locale"];
    [context setValue:nil forKey:@"ip"];
    [context setValue:nil forKey:@"userAgent"];
    
    // parameter object
    NSMutableDictionary *parametersDict=[[NSMutableDictionary alloc] init];
    // TODO: Populate appID from config
    [parametersDict setValue:@"123" forKey:@"app_id"];
    [parametersDict setValue:context forKey:@"context"];
    [parametersDict setValue:batch forKey:@"batch"];
    
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parametersDict
    options:NSJSONWritingPrettyPrinted
      error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://ads.tiktok.com/open_api/v1.1"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // TODO: get access token from TikTok SDK initialization
    [request setValue:@"XX" forHTTPHeaderField:@"Access-Token"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    // TODO: Remove test get request below
//    [request setURL:[NSURL URLWithString:@"https://ads.tiktok.com/marketing-partners/api/partner/get"]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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
        
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"Request reply: %@", requestReply);
        
    }] resume];
}

@end
