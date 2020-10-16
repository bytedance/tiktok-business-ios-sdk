//
//  TikTokTypeUtility.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 10/16/20.
//  Copyright © 2020 bytedance. All rights reserved.
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
