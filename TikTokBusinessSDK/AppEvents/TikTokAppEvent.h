//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokAppEvent : NSObject<NSCopying, NSSecureCoding>
/**
 * @brief Name of event
 */
@property (nonatomic, copy, nonnull) NSString *eventName;

/**
 * @brief Timestamp
 */
@property (nonatomic, nonnull) NSString *timestamp;

/**
 * @brief Additional properties in the form of NSDictionary
 */
@property (nonatomic) NSDictionary *properties;

- (instancetype)initWithEventName: (NSString *)eventName;

- (instancetype)initWithEventName: (NSString *)eventName
                   withProperties: (NSDictionary *)properties;

@end

NS_ASSUME_NONNULL_END
