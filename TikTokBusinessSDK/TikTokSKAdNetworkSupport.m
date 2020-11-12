//
//  TikTokSKAdNetworkSupport.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 10/24/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokSKAdNetworkSupport.h"

@interface TikTokSKAdNetworkSupport()

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
        self.skAdNetworkClass = NSClassFromString(@"SKAdNetwork");
        self.skAdNetworkRegisterAppForAdNetworkAttribution = NSSelectorFromString(@"registerAppForAdNetworkAttribution");
    }
    return self;
}

- (void)registerAppForAdNetworkAttribution
{
    if (@available(iOS 14.0, *)) {
        ((id (*)(id, SEL))[self.skAdNetworkClass methodForSelector:self.skAdNetworkRegisterAppForAdNetworkAttribution])(self.skAdNetworkClass, self.skAdNetworkRegisterAppForAdNetworkAttribution);
    }
}

@end
