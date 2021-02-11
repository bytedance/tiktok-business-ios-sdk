//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokIdentifyUtility : NSObject

+ (NSString *)getOrGenerateAnonymousID;

+ (NSString *)generateNewAnonymousID;

+ (void)setUserInfoDefaultsWithExternalID:(nullable NSString *)externalID
                         externalUserName:(nullable NSString *)externalUserName
                              phoneNumber:(nullable NSString *)phoneNumber
                                    email:(nullable NSString *)email
                                   origin:(nullable NSString *)origin;

+ (NSDictionary *)getUserInfoDictionaryFromNSUserDefaults;

+ (void)resetNSUserDefaults;

@end

NS_ASSUME_NONNULL_END
