//
//  TikTokAppEventRequestHandler.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/17/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokAppEventRequestHandler : NSObject

+ (void)sendPOSTRequest:(NSMutableArray *)eventsToBeFlushed;

@end

NS_ASSUME_NONNULL_END
