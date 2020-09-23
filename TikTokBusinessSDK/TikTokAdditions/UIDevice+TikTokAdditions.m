//
//  UIDevice+TikTokAdditions.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/22/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "UIDevice+TikTokAdditions.h"
#import "NSString+TikTokAdditions.h"
#import <sys/sysctl.h>

#if !TIKTOK_NO_IDFA
#import <AdSupport/ASIdentifierManager.h>
#endif

#if !TIKTOK_NO_IAD
#import <iAd/iAd.h>
#endif

@implementation UIDevice(TikTokAdditions)

- (Class)adSupportManager
{
    NSString *className = [NSString tiktokJoin:@"A", @"S", @"identifier", @"manager", nil];
    Class class = NSClassFromString(className);
    return class;
}

- (Class)appTrackingManager
{
    NSString *className = [NSString tiktokJoin:@"A", @"T", @"tracking", @"manager", nil];
    Class class = NSClassFromString(className);
    return class;
}

- (int)tiktokATTStatus
{
    Class appTrackingClass = [self appTrackingManager];
    if(appTrackingClass != nil) {
        NSString *keyAuthorization = [NSString tiktokJoin:@"tracking", @"authorization", @"status", nil];
        SEL selAuthorization = NSSelectorFromString(keyAuthorization);
        if([appTrackingClass respondsToSelector:selAuthorization]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-avilability"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return (int)[appTrackingClass performSelector:selAuthorization];
#pragma clang diagnostic pop
        }
    }
    return -1;
}

- (void)requestTrackingAuthorizationWithCompletionHandler:(void (^)(NSUInteger))completion
{
    Class appTrackingClass = [self appTrackingManager];
    if(appTrackingClass == nil) {
        return;
    }
    NSString *requestAuthorization = [NSString tiktokJoin: @"request", @"tracking", @"authorization", @"with", @"completion", @"handler:", nil];
    SEL selRequestAuthorization = NSSelectorFromString(requestAuthorization);
    if(![appTrackingClass respondsToSelector:selRequestAuthorization]) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [appTrackingClass performSelector:selRequestAuthorization withObject:completion];
#pragma clang diagnostic pop
}

- (BOOL)tiktokTrackingEnabled
{
#if TIKTOK_NO_IDFA
    return NO;
#else
    Class adSupportClass = [self adSupportManager];
    if(adSupportClass == nil){
        return NO;
    }
    
    
    NSString *keyManager = [NSString tiktokJoin:@"shared", @"manager", nil];
    SEL selManager = NSSelectorFromString(keyManager);
    if (![adSupportClass respondsToSelector:selManager]) {
        return NO;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id manager = [adSupportClass performSelector:selManager];
    
    NSString *keyEnabled = [NSString tiktokJoin:@"is", @"advertising", @"tracking", @"enabled", nil];
    SEL selEnabled = NSSelectorFromString(keyEnabled);
    if (![manager respondsToSelector:selEnabled]) {
        return NO;
    }
    BOOL enabled = (BOOL)[manager performSelector:selEnabled];
    return enabled;
#pragma clang diagnostic pop
#endif

}

- (NSString *)tiktokIdForAdvertisers
{
#if TIKTOK_NO_IDFA
    return @""
#else
    Class adSupportClass = [self adSupportManager];
    if (adSupportClass == nil) {
        return @"";
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    NSString *keyManager = [NSString tiktokJoin:@"shared", @"manager", nil];
    SEL selManager = NSSelectorFromString(keyManager);
    if (![adSupportClass respondsToSelector:selManager]) {
        return @"";
    }
    id manager = [adSupportClass performSelector:selManager];

    NSString *keyIdentifier = [NSString tiktokJoin:@"advertising", @"identifier", nil];
    SEL selIdentifier = NSSelectorFromString(keyIdentifier);
    if (![manager respondsToSelector:selIdentifier]) {
        return @"";
    }
    id identifier = [manager performSelector:selIdentifier];

    NSString *keyString = [NSString tiktokJoin:@"UUID", @"string", nil];
    SEL selString = NSSelectorFromString(keyString);
    if (![identifier respondsToSelector:selString]) {
        return @"";
    }
    NSString *string = [identifier performSelector:selString];
    return string;

#pragma clang diagnostic pop
#endif
}

- (NSString *)tiktokDeviceType
{
    NSString *type = [self.model stringByReplacingOccurrencesOfString:@" " withString:@""];
    return type;
}

- (NSString *)tiktokDeviceName
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *machine = [NSString stringWithUTF8String:name];
    free(name);
    return machine;
}

- (NSString *)tiktokCreateUuid {
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *uuidString = (__bridge_transfer NSString*)stringRef;
    NSString *lowerUuid = [uuidString lowercaseString];
    CFRelease(newUniqueId);
    return lowerUuid;
}

- (NSString *)tiktokVendorId
{
    if ([UIDevice.currentDevice respondsToSelector:@selector(identifierForVendor)]) {
        return [UIDevice.currentDevice.identifierForVendor UUIDString];
    }
    return @"";
}

//- (NSString *)tiktokDeviceId:(TikTokDeviceInfo *)deviceInfo
//{
//    
//}

@end
