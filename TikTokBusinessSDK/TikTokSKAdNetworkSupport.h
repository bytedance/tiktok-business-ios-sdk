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

/* The maximum time for app install attribution is set to 3 days by default,
 * but this value can be changed using setSKAdNetworkCalloutMaxTimeSinceInstall()
 * through TikTokBusiness
*/
@property (nonatomic, assign, readwrite) NSTimeInterval maxTimeSinceInstall;

+ (TikTokSKAdNetworkSupport *)sharedInstance;
- (void)registerAppForAdNetworkAttribution;

@end

NS_ASSUME_NONNULL_END
