//
//  TikTokAppEventUtility.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/10/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokAppEventUtility : NSObject

+ (dispatch_source_t)startTimerWithInterval:(double)interval block:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
