//
//  TikTokAppEvent.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokAppEvent : NSObject
/**
 * @brief Application ID
 */
@property (nonatomic, copy, readonly, nonnull) NSString *appID;

/**
 * @brief Name of event
 */
@property (nonatomic, copy, nonnull) NSString *eventName;

/**
 * @brief Timestamp
 */
@property (nonatomic, readonly) NSTimeInterval timestamp;

/**
 * @brief Additional parameters in the form of a JSON object
 * TODO: if should be NSDictionary parameters, remove this
 */
@property (nonatomic, copy, readonly, nonnull) NSString *jsonParameters;

/**
 * @brief Additional parameters in the form of NSDictionary
 * TODO: if should be json parameters, remove this
 */
@property (nonatomic) NSDictionary *parameters;

- (instancetype)initWithEventName: (NSString *)eventName;

@end

NS_ASSUME_NONNULL_END
