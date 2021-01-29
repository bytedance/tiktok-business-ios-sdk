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

+ (NSDictionary *)generateUserInfoWithExternalID:(NSString *)externalID
                                externalUserName:(NSString *)externalUserName
                                     phoneNumber:(NSString *)phoneNumber
                                               email:(NSString *)email;

+ (void)resetNSUserDefaults;

@end

NS_ASSUME_NONNULL_END
