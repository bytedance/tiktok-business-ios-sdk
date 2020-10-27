//
//  TikTokSKAdNetworkSupport.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 10/24/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokSKAdNetworkSupport : NSObject

@property (nonatomic, assign, readwrite) NSTimeInterval maxTimeSinceInstall;

+ (TikTokSKAdNetworkSupport *)sharedInstance;
- (void)registerAppForAdNetworkAttribution;
- (void)updateConversionValue:(NSInteger)conversionValue;

@end

NS_ASSUME_NONNULL_END
