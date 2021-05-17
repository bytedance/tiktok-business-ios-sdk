//
//  TikTokSKAdNetworkConversionConfiguration.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 5/5/21.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TikTokSKAdNetworkRule.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokSKAdNetworkConversionConfiguration : NSObject

@property (nonatomic, readonly, copy) NSMutableArray<TikTokSKAdNetworkRule *> *conversionValueRules;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> *conversionValueConfig;

+ (TikTokSKAdNetworkConversionConfiguration *)sharedInstance;
- (nullable instancetype)initWithJSON:(nullable NSDictionary<NSString *, id> *)dict;
- (void)logAllRules;

@end

NS_ASSUME_NONNULL_END
