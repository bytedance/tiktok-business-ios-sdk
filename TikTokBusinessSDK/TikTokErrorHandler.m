//
//  TikTokErrorHandler.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 10/15/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokErrorHandler.h"
#import "TikTokBusiness.h"
#import "TikTokFactory.h"

@implementation TikTokErrorHandler

static void handleUncaughtException(NSException *exception)
{
    [TikTokErrorHandler handleErrorWithOrigin:NSStringFromClass([TikTokErrorHandler class]) message:@"Uncaught Exception" exception:exception];
}

+ (void)handleErrorWithOrigin:(NSString *)origin
                      message:(NSString *)message
                    exception:(NSException *)exception {
    [[TikTokFactory getLogger] error:@"[%@] %@ (%@) \n %@", origin, message, exception, [exception callStackSymbols]];
}

+ (void)handleErrorWithOrigin:(NSString *)origin
                      message:(NSString *)message {
    [[TikTokFactory getLogger] error:@"[%@] %@", origin, message];
}

NSUncaughtExceptionHandler *handleUncaughtExceptionPointer = &handleUncaughtException;

@end
