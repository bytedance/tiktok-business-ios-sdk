//
//  TikTokPaymentObserver.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/25/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokPaymentObserver.h"
#import "TikTok.h"
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>

@interface TikTokPaymentObserver () <SKPaymentTransactionObserver>
@end

@implementation TikTokPaymentObserver
{
    BOOL _observingTransactions;
}

+ (void)startObservingTransactions
{
    [[self singleton] startObservingTransactions];
}

+ (void)stopObservingTransactions
{
    [[self singleton] stopObservingTransactions];
}

#pragma mark - Internal Methods

+ (TikTokPaymentObserver *)singleton
{
    static dispatch_once_t pred;
    static TikTokPaymentObserver *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[TikTokPaymentObserver alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _observingTransactions = NO;
  }
  return self;
}

-(void)startObservingTransactions
{
    @synchronized (self) {
        if(!_observingTransactions) {
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            _observingTransactions = YES;
        }
    }
}

-(void)stopObservingTransactions
{
    @synchronized (self) {
        if(_observingTransactions) {
            [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
            _observingTransactions = NO;
        }
    }
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    for(SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
          case SKPaymentTransactionStatePurchasing:
          case SKPaymentTransactionStatePurchased:
          case SKPaymentTransactionStateFailed:
          case SKPaymentTransactionStateRestored:
            [self handleTransaction:transaction];
            break;
          case SKPaymentTransactionStateDeferred:
            break;
        }
    }
}

-(void)handleTransaction: (SKPaymentTransaction *)transaction
{
    [[TikTok getInstance] trackEvent: [[TikTokAppEvent alloc] initWithEventName:@"PURCHASE" withParameters: [NSData alloc]]];
}

@end
