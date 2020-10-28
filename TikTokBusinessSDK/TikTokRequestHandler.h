//
//  TikTokRequestHandler.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/17/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TikTokConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TikTokRequestHandler : NSObject

@property (atomic, strong, nullable) NSURLSession *session;
@property (atomic, strong) NSString *apiVersion;

/**
 * @brief Method to obtain remote switch with completion handler
 */
- (void)getRemoteSwitch:(TikTokConfig *)config
        withCompletionHandler:(void (^)(BOOL isRemoteSwitchOn))completionHandler;

/**
 * @brief Method to interact with '/batch' endpoint
 */
- (void)sendBatchRequest:(NSArray *)eventsToBeFlushed
              withConfig:(TikTokConfig *)config;

@end

NS_ASSUME_NONNULL_END
