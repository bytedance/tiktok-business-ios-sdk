//
//  TikTokSKAdNetworkRule.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 5/5/21.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikTokSKAdNetworkRule : NSObject

@property (nonatomic) NSInteger conversionValue;
@property (nonatomic, copy) NSArray<TikTokSKAdNetworkEvent *> *events;

- (nullable instancetype)initWithJSON:(NSDictionary<NSString *, id> *)dict;
- (BOOL)isMatchedWith

@end

NS_ASSUME_NONNULL_END
