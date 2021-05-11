//
//  TikTokSKAdNetworkEvent.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 5/10/21.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "TikTokSKAdNetworkEvent.h"

@implementation TikTokSKAdNetworkEvent

@property (nonatomic, readonly, copy) NSString *eventName;
@property(nullable, nonatomic, readonly, copy) NSDictionary<NSString *, NSNumber *> *values;

- (nullable instancetype)initWithJSON:(NSDictionary<NSString *, id> *)dict;

@end
