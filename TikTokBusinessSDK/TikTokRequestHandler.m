//
//  TikTokRequestHandler.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/17/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokAppEvent.h"
#import "TikTokRequestHandler.h"
#import "TikTokAppEventStore.h"
#import "TikTokDeviceInfo.h"
#import "TikTokConfig.h"
#import "TikTok.h"
#import "TikTokLogger.h"
#import "TikTokFactory.h"
#import "TikTokTypeUtility.h"

@interface TikTokRequestHandler()

@property (nonatomic, weak) id<TikTokLogger> logger;

@end

@implementation TikTokRequestHandler

- (id)init:(TikTokConfig *)config
{
    if (self == nil) {
        return nil;
    }
    
    self.logger = [TikTokFactory getLogger];
    
    return self;
}

- (void) getRemoteSwitchWithCompletionHandler: (void (^) (BOOL isRemoteSwitchOn)) completionHandler
{
    // TODO: Update parameters and url to actual endpoint for remote switch
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://ads.tiktok.com/marketing-partners/api/partner/get"]];
    [request setHTTPMethod:@"GET"];
    
    if(self.logger == nil) {
        self.logger = [TikTokFactory getLogger];
    }
    if(self.session == nil) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL isSwitchOn = nil;
        // handle basic connectivity issues
        if(error) {
            [self.logger error:@"[TikTokRequestHandler] error in connection", error];
            // leave switch to on if error on request
            isSwitchOn = YES;
            completionHandler(isSwitchOn);
            return;
        }
        
        // handle HTTP errors
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            
            if (statusCode != 200) {
                [self.logger error:@"[TikTokRequestHandler] HTTP error status code: %lu", statusCode];
                // leave switch to on if error on request
                isSwitchOn = YES;
                completionHandler(isSwitchOn);
                return;
            }
            
        }
        
        id dataDictionary = [TikTokTypeUtility JSONObjectWithData:data options:0 error:nil origin:NSStringFromClass([self class])];
        
        if([dataDictionary isKindOfClass:[NSDictionary class]]) {
            NSNumber *code = [dataDictionary objectForKey:@"code"];
            // code != 0 indicates error from API call
            if([code intValue] != 0) {
                NSString *message = [dataDictionary objectForKey:@"message"];
                [self.logger error:@"[TikTokRequestHandler] code error: %@, message: %@", code, message];
                // leave switch to on if error on request
                isSwitchOn = YES;
                completionHandler(isSwitchOn);
                return;
            }
        }
        
        // NSString *requestResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        // [self.logger info:@"[TikTokRequestHandler] Request response from check remote switch: %@", requestResponse];
        
        // TODO: Update isSwitchOn based on TiktokBusinessSdkConfig.enableSdk from response
        isSwitchOn = YES;
        completionHandler(isSwitchOn);
    }] resume];
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
    
    if(self.logger == nil) {
        self.logger = [TikTokFactory getLogger];
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
        @"app_id" : @"com.shopee.my",
        @"batch": batch,
        @"context": context,
    };
    
    NSData *postData = [TikTokTypeUtility dataWithJSONObject:parametersDict options:NSJSONWritingPrettyPrinted error:nil origin:NSStringFromClass([self class])];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    // TODO: Logs below to view JSON passed to request. Remove once convert to prod API
    // NSString *postDataJSONString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    // [self.logger info:@"[TikTokRequestHandler] Access token: %@", config.appToken];
    // [self.logger info:@"[TikTokRequestHandler] postDataJSON: %@", postDataJSONString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://ads.tiktok.com/open_api/v1.1/app/track/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:config.appToken forHTTPHeaderField:@"Access-Token"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    if(self.session == nil) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // handle basic connectivity issues
        if(error) {
            [self.logger error:@"[TikTokRequestHandler] error in connection", error];
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
                [self.logger error:@"[TikTokRequestHandler] HTTP error status code: %lu", statusCode];
                @synchronized(self) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TikTokAppEventStore persistAppEvents:eventsToBeFlushed];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"inDiskEventQueueUpdated" object:nil];
                    });
                }
                return;
            }
            
        }
        
        id dataDictionary = [TikTokTypeUtility JSONObjectWithData:data options:0 error:nil origin:NSStringFromClass([self class])];
        
        if([dataDictionary isKindOfClass:[NSDictionary class]]) {
            NSNumber *code = [dataDictionary objectForKey:@"code"];
            // code != 0 indicates error from API call
            if([code intValue] != 0) {
                NSString *message = [dataDictionary objectForKey:@"message"];
                [self.logger error:@"[TikTokRequestHandler] code error: %@, message: %@", code, message];
                @synchronized(self) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TikTokAppEventStore persistAppEvents:eventsToBeFlushed];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"inDiskEventQueueUpdated" object:nil];
                    });
                }
                return;
            }
            
        }
        
        NSString *requestResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        [self.logger info:@"[TikTokRequestHandler] Request response: %@", requestResponse];
    }] resume];
}

@end
