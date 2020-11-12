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

/**
 * @brief This class is used to fetch User Agent from WebKit
*/
@interface TikTokUserAgentCollector : NSObject

@property (nonatomic, copy, readwrite) NSString *userAgent;

+ (TikTokUserAgentCollector *)singleton;

/**
 * @brief Handles asynchronous Javascript call to the WebKit browser
*/
- (void)loadUserAgentWithCompletion:(void(^)(NSString * _Nullable userAgent))completion;
+ (void)setUserAgent:(NSString *)userAgent;
- (void)setUserAgent:(NSString *)userAgent;

@end

NS_ASSUME_NONNULL_END
