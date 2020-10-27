//
//  TikTokUserAgentCollector.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 10/23/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKWebView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokUserAgentCollector : NSObject

@property (nonatomic, copy, readwrite) NSString *userAgent;

+ (TikTokUserAgentCollector *)singleton;
- (void)loadUserAgentWithCompletion:(void(^)(NSString * _Nullable userAgent))completion;

@end

NS_ASSUME_NONNULL_END
