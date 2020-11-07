//
//  TikTokFactory.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 10/9/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TikTokLogger.h>
#import <TikTokRequestHandler.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief Handles shared classes like TikTokLogger across multiple objects
*/
@interface TikTokFactory : NSObject

+ (id<TikTokLogger>)getLogger;
+ (void)setLogger:(id<TikTokLogger>)logger;
+ (TikTokRequestHandler*)getRequestHandler;

@end

NS_ASSUME_NONNULL_END
