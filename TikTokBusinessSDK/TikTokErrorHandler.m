//
//  TikTokErrorHandler.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 10/15/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokErrorHandler.h"
#import "TikTok.h"

@implementation TikTokErrorHandler

+ (void)handleErrorWithOrigin:(NSString *)origin
                      message:(NSString *)message
                    exception:(NSException *)exception {
    [[[TikTok getInstance] logger] error:@"[%@] %@ (%@)", origin, message, exception];
    // TODO: implement error API call
}

+ (void)handleErrorWithOrigin:(NSString *)origin
                      message:(NSString *)message {
    [[[TikTok getInstance] logger] error:@"[%@] %@", origin, message];
    // TODO: implement error API call
}
@end
