//
//  TikTokLogger.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/6/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {

    TikTokLogLevelVerbose = 1,
    TikTokLogLevelDebug = 2,
    TikTokLogLevelInfo = 3,
    TikTokLogLevelWarn = 4,
    TikTokLogLevelError = 5,
    TikTokLogLevelAssert = 6,
    TikTokLogLevelSuppress = 7

} TikTokLogLevel;

@protocol TikTokLogger

- (void)setLogLevel: (TikTokLogLevel)logLevel isProductionEnvironment: (BOOL)isProductionEnvironment;

- (void)lockLogLevel;

- (void)verbose: (nonnull NSString *)message, ...;

- (void)debug: (nonnull NSString *)message, ...;

- (void)info: (nonnull NSString *)message, ...;

- (void)warn: (nonnull NSString *)message, ...;

- (void)warnInProduction: (nonnull NSString *)message, ...;

- (void)error: (nonnull NSString *)message, ...;

- (void)assert: (nonnull NSString *)message, ...;

@end

@interface TikTokLogger : NSObject<TikTokLogger>

+ (TikTokLogLevel)logLevelFromString: (nonnull NSString *)logLevelString;

@end

NS_ASSUME_NONNULL_END
