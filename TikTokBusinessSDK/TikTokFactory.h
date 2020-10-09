//
//  TikTokFactory.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 10/9/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TikTokLogger.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokFactory : NSObject

+ (id<TikTokLogger>)getLogger;
+ (void)setLogger:(id<TikTokLogger>)logger;

@end

NS_ASSUME_NONNULL_END
