//
//  TikTokUserAgentCollector.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 10/23/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokUserAgentCollector.h"
#import <WebKit/WKWebView.h>

@interface TikTokUserAgentCollector()

@property (nonatomic, strong, readwrite) WKWebView *webView;

@end

@implementation TikTokUserAgentCollector

+ (TikTokUserAgentCollector *)singleton
{
    static TikTokUserAgentCollector *collector;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collector = [TikTokUserAgentCollector new];
    });
    return collector;
}

- (instancetype)init
{
    self = [super init];
    if(self == nil){
        return nil;
    }
    return self;
}

- (void)loadUserAgentWithCompletion:(void (^)(NSString * _Nullable))completion
{
    [self collectUserAgentWithCompletion: ^(NSString * _Nullable userAgent) {
        self.userAgent = userAgent;
        if(completion){
            completion(userAgent);
        }
    }];
}

- (void)collectUserAgentWithCompletion:(void (^)(NSString *userAgent))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.webView) {
            self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        }
        
        [self.webView evaluateJavaScript:@"navigator.userAgent;" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            if (completion) {
                if (response) {
                    // release the webview
                    self.webView = nil;
                    
                    completion(response);
                } else {
                    // retry if we failed to obtain user agent.  This occasionally occurs on simulator.
                    [self collectUserAgentWithCompletion:completion];
                }
            }
        }];
    });
}

@end
