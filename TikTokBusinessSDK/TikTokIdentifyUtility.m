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
        [preferences synchronize];
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

+ (void)setUserInfoDefaultsWithExternalID:(nullable NSString *)externalID
                                externalUserName:(nullable NSString *)externalUserName
                                     phoneNumber:(nullable NSString *)phoneNumber
                                           email:(nullable NSString *)email
{
    NSString* hashedExternalID = [TikTokTypeUtility toSha256:externalID];
    NSString* hashedExternalUserName = [TikTokTypeUtility toSha256:externalUserName];
    NSString* hashedPhoneNumber = [TikTokTypeUtility toSha256:phoneNumber];
    NSString* hashedEmail = [TikTokTypeUtility toSha256:email];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
 
    NSString *isIdentifiedKey = @"IsIdentified";
    NSString *externalIDKey = @"ExternalID";
    NSString *externalNameKey = @"ExternalName";
    NSString *phoneNumberKey = @"PhoneNumber";
    NSString *emailKey = @"Email";
    
    [preferences setObject:@"true" forKey:isIdentifiedKey];
    [preferences setObject:hashedExternalID forKey:externalIDKey];
    [preferences setObject:hashedExternalUserName forKey:externalNameKey];
    [preferences setObject:hashedPhoneNumber forKey:phoneNumberKey];
    [preferences setObject:hashedEmail forKey:emailKey];
    [preferences synchronize];
}

+ (NSDictionary *)getUserInfoDictionaryFromNSUserDefaults
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    NSString *externalIDKey = @"ExternalID";
    NSString *externalNameKey = @"ExternalName";
    NSString *phoneNumberKey = @"PhoneNumber";
    NSString *emailKey = @"Email";
    
    if ([preferences objectForKey:externalIDKey] != nil) {
        [userInfo setObject:[preferences stringForKey:externalIDKey] forKey:@"external_id"];
    }
    if ([preferences objectForKey:externalNameKey] != nil) {
        [userInfo setObject:[preferences stringForKey:externalNameKey] forKey:@"external_username"];
    }
    if ([preferences objectForKey:phoneNumberKey] != nil) {
        [userInfo setObject:[preferences stringForKey:phoneNumberKey] forKey:@"phone_number"];
    }
    if ([preferences objectForKey:emailKey] != nil) {
        [userInfo setObject:[preferences stringForKey:emailKey] forKey:@"email"];
    }
    
    return userInfo;
}

+ (void)resetNSUserDefaults
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *isIdentifiedKey = @"IsIdentified";
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
    [preferences setObject:@"false" forKey:isIdentifiedKey];
    [preferences synchronize];
}


@end
