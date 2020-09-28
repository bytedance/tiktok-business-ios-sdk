//
//  TikTokPaymentObserver.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/25/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(PaymentObserver)
@interface TikTokPaymentObserver : NSObject
+ (void)startObservingTransactions;
+ (void)stopObservingTransactions;
@end

NS_ASSUME_NONNULL_END
