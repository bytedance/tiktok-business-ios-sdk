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
#import "TikTokDeviceInfo.h"
#import "TikTokConfig.h"
#import "TikTok.h"

@implementation TikTokAppEventRequestHandler

- (id)init:(TikTokConfig *)config
{
    if (self == nil) {
        return nil;
    }
    
    return self;
}

- (void)sendPOSTRequest:(NSArray *)eventsToBeFlushed
             withConfig:(TikTokConfig *)config {
    
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
    
    TikTokDeviceInfo *deviceInfo = [TikTokDeviceInfo deviceInfoWithSdkPrefix:@""];
    NSDictionary *app = @{
        @"name" : deviceInfo.appName,
        @"namespace": deviceInfo.appNamespace,
        @"version": deviceInfo.appVersion,
        @"build": deviceInfo.appBuild,
    };
    
    NSDictionary *device = @{
        @"platform" : deviceInfo.devicePlatform,
        @"idfa": deviceInfo.deviceIdForAdvertisers,
        @"idfv": deviceInfo.deviceVendorId,
    };
    
    NSDictionary *context = @{
        @"app": app,
        @"device": device,
        @"locale": deviceInfo.localeInfo,
        @"ip": deviceInfo.ipInfo,
        @"userAgent": deviceInfo.userAgent,
    };
    
    NSDictionary *parametersDict = @{
        // TODO: Populate appID once change to prod environment
        // @"app_id" : deviceInfo.appId,
        @"app_id" : @"1211123727",
        @"batch": batch,
        @"context": context,
    };
    
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parametersDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    // TODO: Logs below to view JSON passed to request. Remove once convert to prod API
    // NSString *postDataJSONString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    // [[[TikTok getInstance] logger] info:@"Access token: %@", config.appToken];
    // [[[TikTok getInstance] logger] info:@"postDataJSON: %@", postDataJSONString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // TODO: Update URL to "https://ads.tiktok.com/open_api/2/app/batch/"
    [request setURL:[NSURL URLWithString:@"http://10.231.18.38:9496/open_api/2/app/batch/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // TODO: use config.appToken for Access Token once convert to prod API
    [request setValue:@"abcdabcdabcdabcd00509731ca2343bbecb2b846" forHTTPHeaderField:@"Access-Token"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    // TODO: Remove 'x-use-boe' and 'x-tt-env' once release in prod
    [request setValue:@"1" forHTTPHeaderField:@"x-use-boe"];
    [request setValue:@"jianyi" forHTTPHeaderField:@"x-tt-env"];
    [request setHTTPBody:postData];
    
    if(self.session == nil) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // handle basic connectivity issues
        if(error) {
            [[[TikTok getInstance] logger] error:@"error in connection", error];
            @synchronized(self) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [TikTokAppEventStore persistAppEvents:eventsToBeFlushed];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"inDiskEventQueueUpdated" object:nil];
                });
            }
            return;
        }
        
        // handle HTTP errors
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            
            if (statusCode != 200) {
                [[[TikTok getInstance] logger] error:@"HTTP error status code: %lu", statusCode];
                @synchronized(self) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TikTokAppEventStore persistAppEvents:eventsToBeFlushed];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"inDiskEventQueueUpdated" object:nil];
                    });
                }
                return;
            }
            
        }
        
        NSError *dataError = nil;
        id dataDictionary = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:0
                             error:&dataError];
        
        if([dataDictionary isKindOfClass:[NSDictionary class]]) {
            NSNumber *code = [dataDictionary objectForKey:@"code"];
            NSSet<NSNumber *> *nonretryableErrorCodeSet = [NSSet setWithArray:
                                                           @[
                                                               @40000, // CODE_INVALID_PARAMS
                                                               @40001, // CODE_PERMISSION_DENIED, CODE_PARAM_ERROR
                                                               @40002, // CODE_PERMISSION_ERROR
                                                               @40104, // CODE_EMPTY_ACCESS_TOKEN
                                                               @40105, // CODE_INVALID_ACCESS_TOKEN
                                                           ]];
            // code != 0 indicates error from API call
            if([code intValue] != 0) {
                NSString *message = [dataDictionary objectForKey:@"message"];
                NSLog(@"code error: %@, message: %@", code, message);
                // if error code is retryable, persist app events to disk
                if(![nonretryableErrorCodeSet containsObject:code]) {
                    @synchronized(self) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [TikTokAppEventStore persistAppEvents:eventsToBeFlushed];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"inDiskEventQueueUpdated" object:nil];
                        });
                    }
                }
                return;
            }
            
        }
        
        NSString *requestResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        [[[TikTok getInstance] logger] info:@"Request response: %@", requestResponse];
    }] resume];
}

@end
