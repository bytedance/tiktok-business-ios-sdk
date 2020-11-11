//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokTypeUtility : NSObject

/**
 * @brief Safety wrapper around Foundation's NSJSONSerialization:dataWithJSONObject:options:error:
 */
+ (nullable NSData *)dataWithJSONObject:(id)obj
                                options:(NSJSONWritingOptions)opt
                                  error:(NSError **)error
                                 origin:(NSString *)origin;

/**
 * @brief Safety wrapper around Foundation's NSJSONSerialization:JSONObjectWithData:options:error:
 */
+ (nullable id)JSONObjectWithData:(NSData *)data
                          options:(NSJSONReadingOptions)opt
                            error:(NSError **)error
                           origin:(NSString *)origin;

@end

NS_ASSUME_NONNULL_END
