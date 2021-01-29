//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
//

#import "TikTokIdentifyUtility.h"
#import "TikTokTypeUtility.h"

@implementation TikTokIdentifyUtility


+ (NSString *)getOrGenerateAnonymousID
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *anonymousIDkey = @"AnonymousID";
    NSString *anonymousID = nil;
    
    if ([preferences objectForKey:anonymousIDkey] == nil)
    {
        anonymousID = [self generateNewAnonymousID];
        [preferences setObject:anonymousID forKey:anonymousIDkey];
    }   else {
        anonymousID = [preferences stringForKey:anonymousIDkey];
    }
    return anonymousID;
}

+ (NSString *)generateNewAnonymousID
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

+ (NSDictionary *)generateUserInfoWithExternalID:(NSString *)externalID
                                externalUserName:(NSString *)externalUserName
                                     phoneNumber:(NSString *)phoneNumber
                                           email:(NSString *)email
{
    NSString* hashedExternalID = [TikTokTypeUtility toSha256:externalID];
    NSString* hashedExternalUserName = [TikTokTypeUtility toSha256:externalUserName];
    NSString* hashedPhoneNumber = [TikTokTypeUtility toSha256:phoneNumber];
    NSString* hashedEmail = [TikTokTypeUtility toSha256:email];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *externalIDKey = @"ExternalID";
    NSString *externalNameKey = @"ExternalName";
    NSString *phoneNumberKey = @"PhoneNumber";
    NSString *emailKey = @"Email";
    
    [preferences setObject:hashedExternalID forKey:externalIDKey];
    [preferences setObject:hashedExternalUserName forKey:externalNameKey];
    [preferences setObject:hashedPhoneNumber forKey:phoneNumberKey];
    [preferences setObject:hashedEmail forKey:emailKey];
    
    NSDictionary *userInfo = @{
        @"external_id" : hashedExternalID,
        @"external_username": hashedExternalUserName,
        @"phone_number": hashedPhoneNumber,
        @"email": hashedEmail,
    };
    
    return userInfo;
}

+ (void)resetNSUserDefaults
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *anonymousIDkey = @"AnonymousID";
    NSString *externalIDKey = @"ExternalID";
    NSString *externalNameKey = @"ExternalName";
    NSString *phoneNumberKey = @"PhoneNumber";
    NSString *emailKey = @"Email";
    
    [preferences setObject:nil forKey:anonymousIDkey];
    [preferences setObject:nil forKey:externalIDKey];
    [preferences setObject:nil forKey:externalNameKey];
    [preferences setObject:nil forKey:phoneNumberKey];
    [preferences setObject:nil forKey:emailKey];
}


@end
