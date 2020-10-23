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

- (void)getRemoteSwitch:(TikTokConfig *)config
        withCompletionHandler:(void (^)(BOOL isRemoteSwitchOn))completionHandler;

- (void)sendBatchRequest:(NSArray *)eventsToBeFlushed
              withConfig:(TikTokConfig *)config;

@end

NS_ASSUME_NONNULL_END
