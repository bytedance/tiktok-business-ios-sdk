//
//  TikTokSKAdNetworkSupport.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 10/24/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokSKAdNetworkSupport.h"

@interface TikTokSKAdNetworkSupport()

@property (nonatomic, copy, readwrite) NSDate *installDate;
@property (nonatomic, strong, readwrite) Class skAdNetworkClass;
@property (nonatomic, assign, readwrite) SEL skAdNetworkRegisterAppForAdNetworkAttribution;

@end


@implementation TikTokSKAdNetworkSupport

+ (TikTokSKAdNetworkSupport *)sharedInstance
{
    static TikTokSKAdNetworkSupport *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[TikTokSKAdNetworkSupport alloc]init];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.maxTimeSinceInstall = 3600.0 * 24.0 * 3.0; // 3 days
        self.installDate = (NSDate *)[defaults objectForKey:@"tiktokInstallDate"];
        self.skAdNetworkClass = NSClassFromString(@"SKAdNetwork");
        self.skAdNetworkRegisterAppForAdNetworkAttribution = NSSelectorFromString(@"registerAppForAdNetworkAttribution");
    }
    return self;
}

- (BOOL)shouldAttemptSKAdNetworkCallout
{
    if(self.installDate && self.skAdNetworkClass) {
        NSDate *now = [NSDate date];
        NSDate *maxDate = [self.installDate dateByAddingTimeInterval:self.maxTimeSinceInstall];
        if([now compare:maxDate] == NSOrderedDescending) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

- (void)registerAppForAdNetworkAttribution
{
    if (@available(iOS 14.0, *)) {
        if([self shouldAttemptSKAdNetworkCallout]) {
            ((id (*)(id, SEL))[self.skAdNetworkClass methodForSelector:self.skAdNetworkRegisterAppForAdNetworkAttribution])(self.skAdNetworkClass, self.skAdNetworkRegisterAppForAdNetworkAttribution);
        }
    }
}

@end
