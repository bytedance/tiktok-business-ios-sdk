//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
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
