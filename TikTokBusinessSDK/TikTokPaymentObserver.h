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

/**
 * @brief This class handles observation of successful Native iOS payments
 *        The startObservingTransaction and stopObservation functions can be
 *        called to enable or disable this functionality
*/
@interface TikTokPaymentObserver : NSObject

+ (void)startObservingTransactions;
+ (void)stopObservingTransactions;

@end

NS_ASSUME_NONNULL_END
