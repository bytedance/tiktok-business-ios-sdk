//
//  TestTikTokEvent.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestTikTokEvent : NSObject

- (instancetype)initWithName: (NSString *)eventName;
- (void)logEvent;
- (void)lolwut;

@end

NS_ASSUME_NONNULL_END
