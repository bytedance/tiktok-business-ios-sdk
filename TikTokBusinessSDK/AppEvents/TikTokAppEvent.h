//
//  TikTokAppEvent.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokAppEvent : NSObject<NSCopying, NSSecureCoding>
/**
 * @brief Application ID
 */
@property (nonatomic, copy, nonnull) NSString *appID;

/**
 * @brief Name of event
 */
@property (nonatomic, copy, nonnull) NSString *eventName;

/**
 * @brief Timestamp
 */
@property (nonatomic, nonnull) NSNumber *timestamp;

/**
 * @brief Additional parameters in the form of NSDictionary
 */
@property (nonatomic) NSDictionary *parameters;

- (instancetype)initWithEventName: (NSString *)eventName;

@end

NS_ASSUME_NONNULL_END
