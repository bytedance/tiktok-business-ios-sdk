//
//  TikTokErrorHandler.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 10/15/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSUncaughtExceptionHandler *handleUncaughtExceptionPointer;

@interface TikTokErrorHandler : NSObject

/**
 * @brief Error handling with exception
 */
+ (void)handleErrorWithOrigin:(NSString *)origin
                      message:(NSString *)message
                    exception:(NSException *)exception;
/**
 * @brief Error handling without exception
 */
+ (void)handleErrorWithOrigin:(NSString *)origin
                      message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
