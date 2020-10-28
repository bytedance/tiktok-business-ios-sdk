//
//  TikTokPaymentObserver.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/25/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokPaymentObserver.h"
#import "TikTok.h"
#import "TikTokLogger.h"
#import "TikTokFactory.h"
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>

static NSMutableArray *g_pendingRequestors;

@interface TikTokPaymentProductRequestor : NSObject <SKProductsRequestDelegate>

@property (nonatomic, retain) SKPaymentTransaction *transaction;

- (instancetype) initWithTransaction: (SKPaymentTransaction *)transaction;
- (void)resolveProducts;

@end

@interface TikTokPaymentObserver () <SKPaymentTransactionObserver>

@property (nonatomic, weak) id<TikTokLogger> logger;

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
      self.logger = [TikTokFactory getLogger];
  }
  return self;
}

-(void)startObservingTransactions
{
    @synchronized (self) {
        if(!_observingTransactions) {
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            _observingTransactions = YES;
            [self.logger info:@"Starting Transaction Tracking..."];
        }
    }
}

-(void)stopObservingTransactions
{
    @synchronized (self) {
        if(_observingTransactions) {
            [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
            _observingTransactions = NO;
            [self.logger info:@"Stopping Transaction Tracking..."];
        }
    }
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    for(SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self handleTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
            case SKPaymentTransactionStateFailed:
            case SKPaymentTransactionStateRestored:
            case SKPaymentTransactionStateDeferred:
                break;
        }
    }
}

-(void)handleTransaction: (SKPaymentTransaction *)transaction
{
    TikTokPaymentProductRequestor *productRequest = [[TikTokPaymentProductRequestor alloc] initWithTransaction:transaction];
    [productRequest resolveProducts];
//    [[TikTok getInstance] trackPurchase:[[TikTokAppEvent alloc] initWithEventName:@"PURCHASE" withParameters: [NSData alloc]]];
}

@end

@interface TikTokPaymentProductRequestor ()
@property (nonatomic, retain) SKProductsRequest *productRequest;
@end

@implementation TikTokPaymentProductRequestor
{
    NSMutableSet<NSString *> *_originalTransactionSet;
    NSSet<NSString *> *_eventsWithReceipt;
//    NSDateFormatter *_formatter;
}

+ (void)initialize
{
    if([self class] == [TikTokPaymentProductRequestor class]) {
        g_pendingRequestors = [[NSMutableArray alloc] init];
    }
}

- (instancetype)initWithTransaction:(SKPaymentTransaction *)transaction
{
    self = [super init];
    if (self) {
        _transaction = transaction;
//        _formatter = [[NSDateFormatter alloc] init];
//        _formatter.dateFormat = @"yyyy-MM-dd HH:mm:ssZ";
        // TODO: Check what happens if key does not exist
//        NSString *data = [[NSUserDefaults standardUserDefaults] stringForKey:@"com.tiktok.appevents.PaymentObserver.originalTransaction"];
//        _eventsWithReceipt = [NSSet setWithArray:@[@"Purchase", @"Subscribe", @"StartTrial"]];
        NSString *data = [[NSUserDefaults standardUserDefaults] stringForKey:@"com.tiktok.appevents.PaymentObserver.originalTransaction"];
        _eventsWithReceipt = [NSSet setWithArray:@[@"Purchase"]];
        
        if (data) {
            _originalTransactionSet = [NSMutableSet setWithArray:[data componentsSeparatedByString:@","]];
        } else {
            _originalTransactionSet = [[NSMutableSet alloc] init];
        }
    }
    return self;
}

- (void)setProductRequest:(SKProductsRequest *)productRequest
{
    if(productRequest != _productRequest) {
        if(_productRequest){
            _productRequest.delegate = nil;
        }
        _productRequest = productRequest;
    }
}

- (void)resolveProducts
{
    NSString *productId = self.transaction.payment.productIdentifier;
    NSSet *productIdentifiers = [NSSet setWithObjects:productId, nil];
    self.productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productRequest.delegate = self;
    @synchronized (g_pendingRequestors) {
        // TODO: Add Type Safe array here in future version
        [g_pendingRequestors addObject:self];
    }
    [self.productRequest start];
}


//- (BOOL)isSubscription:(SKProduct *)product
//{
//    if (@available(iOS 11.2, *)) {
//        return (product.subscriptionPeriod != nil) && ((unsigned long)product.subscriptionPeriod.numberOfUnits > 0);
//    }
//    return NO;
//}

- (void)logTransactionEvent: (SKProduct *)product
{
//    if([self isSubscription:product]) {
//        [self trackAutomaticSubscribeEvent:self.transaction ofProduct:product];
//    } else {
//        [self trackAutomaticPurchaseEvent:self.transaction ofProduct:product];
//    }
    [self trackAutomaticPurchaseEvent:self.transaction ofProduct:product];
}

- (NSMutableDictionary<NSString *, id> *)getEventParametersOfProduct: (SKProduct *)product withTransaction: (SKPaymentTransaction *)transaction
{
    NSString *transactionId = nil;
//    NSString *transactionDate = nil;
    
    switch (transaction.transactionState) {
        case SKPaymentTransactionStatePurchasing:
            break;
        case SKPaymentTransactionStatePurchased:
            transactionId = self.transaction.transactionIdentifier;
//            transactionDate = [_formatter stringFromDate:self.transaction.transactionDate];
            break;
        case SKPaymentTransactionStateFailed:
            break;
        case SKPaymentTransactionStateRestored:
//            transactionDate = [_formatter stringFromDate:self.transaction.transactionDate];
            break;
        default:
            break;
    }
    SKPayment *payment = transaction.payment;
    
    NSMutableDictionary *eventParameters = [[NSMutableDictionary alloc] initWithDictionary:@{
    }];

    if(product){

        [eventParameters addEntriesFromDictionary:@{
            @"currency": [product.priceLocale objectForKey:NSLocaleCurrencyCode] ? : @"",
//            @"num_items": @(payment.quantity) ? : @"",
            @"description": product.localizedTitle ? : @"",
            @"query":@"",
//            @"name_description": product.localizedDescription ? : @"",
        }];

        NSMutableArray *contents = [[NSMutableArray alloc] init];

        for (NSUInteger idx = 0; idx < payment.quantity; idx++) {
            NSMutableDictionary *productDict = [[NSMutableDictionary alloc] initWithDictionary:@{
                @"price": [[NSNumber numberWithDouble:product.price.doubleValue] stringValue],
                @"quantity": @"1",
                @"content_type": product.productIdentifier,
            }];
            if(transactionId){
                [productDict setObject:transactionId forKey:@"content_id"];
            }
            [contents addObject:productDict];
        }

        [eventParameters setObject:contents forKey:@"contents"];
//        if(transactionId){
//            [eventParameters setObject:transactionId forKey:@"order_id"];
//        }
    }

//    if (@available(iOS 11.2, *)) {
//        if([self isSubscription:product]) {
//            [eventParameters setObject:[self durationOfSubscriptionPeriod:product.subscriptionPeriod] forKey:@"subscription_period"];
//            [eventParameters setObject:@"subs" forKey:@"in_app_purchase_type"];
//            [eventParameters setObject: [self isStartTrial:transaction ofProduct:product] ? @"1" : @"0" forKey:@"is_start_trial"];
//
//            SKProductDiscount *discount = product.introductoryPrice;
//            if(discount) {
//                if (discount.paymentMode == SKProductDiscountPaymentModeFreeTrial) {
//                    [eventParameters setObject:@"1" forKey:@"has_free_trial"];
//                } else {
//                    [eventParameters setObject:@"0" forKey:@"has_free_trial"];
//                }
//                [eventParameters setObject:[self durationOfSubscriptionPeriod:discount.subscriptionPeriod] forKey:@"trial_period"];
//                [eventParameters setObject:discount.price forKey:@"trial_price"];
//            }
//
//        } else {
//            [eventParameters setObject:@"inapp" forKey:@"in_app_purchase_type"];
//        }
//    }

    return eventParameters;
}

- (void)appendOriginalTransactionId:(NSString *)transactionId
{
    if (!transactionId) {
        return;
    }
    [_originalTransactionSet addObject:transactionId];
    [[NSUserDefaults standardUserDefaults] setObject:[[_originalTransactionSet allObjects] componentsJoinedByString:@","] forKey:@"com.tiktok.appevents.PaymentObserver.originalTransaction"];
}

- (void)clearOriginalTransactionId:(NSString *)transactionId
{
    if(!transactionId){
        return;
    }
    [_originalTransactionSet removeObject:transactionId];
    [[NSUserDefaults standardUserDefaults] setObject:[[_originalTransactionSet allObjects] componentsJoinedByString:@","] forKey:@"com.tiktok.appevents.PaymentObserver.originalTransaction"];
}

- (BOOL)isStartTrial:(SKPaymentTransaction *)transaction ofProduct:(SKProduct *)product
{
    if (@available(iOS 12.2, *)) {
        SKPaymentDiscount *paymentDiscount = transaction.payment.paymentDiscount;
        if(paymentDiscount) {
            NSArray<SKProductDiscount *> *discounts = product.discounts;
            for (SKProductDiscount *discount in discounts) {
                if (discount.paymentMode == SKProductDiscountPaymentModeFreeTrial && [paymentDiscount.identifier isEqualToString:discount.identifier]) {
                    return YES;
                }
            }
        }
    }
    
    if (@available(iOS 11.2, *)) {
        if (product.introductoryPrice && product.introductoryPrice.paymentMode == SKProductDiscountPaymentModeFreeTrial) {
            NSString *originalTransactionId = transaction.originalTransaction.transactionIdentifier;
            if (!originalTransactionId) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)hasStartTrial:(SKProduct *)product
{
    if (@available(iOS 12.2, *)) {
        NSArray<SKProductDiscount *> *discounts = product.discounts;
        for (SKProductDiscount *discount in discounts) {
            if (discount.paymentMode == SKProductDiscountPaymentModeFreeTrial) {
                return YES;
            }
        }
    }
    
    if (@available(iOS 11.2, *)) {
        if (product.introductoryPrice && (product.introductoryPrice.paymentMode == SKProductDiscountPaymentModeFreeTrial)) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)durationOfSubscriptionPeriod:(id)subscriptionPeriod
{
    if (@available(iOS 11.2, *)) {
        if (subscriptionPeriod) {
            if (subscriptionPeriod && [subscriptionPeriod isKindOfClass:[SKProductSubscriptionPeriod class]]) {
                SKProductSubscriptionPeriod *period = (SKProductSubscriptionPeriod *)subscriptionPeriod;
                NSString *unit = nil;
                switch (period.unit) {
                    case SKProductPeriodUnitDay: unit = @"D"; break;
                    case SKProductPeriodUnitWeek: unit = @"W"; break;
                    case SKProductPeriodUnitMonth: unit = @"M"; break;
                    case SKProductPeriodUnitYear: unit = @"Y"; break;
                }
                return [NSString stringWithFormat:@"P%lu%@", (unsigned long)period.numberOfUnits, unit];
            }
        }
    }
    return nil;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    NSArray *invalidProductIdentifiers = response.invalidProductIdentifiers;
    if (products.count + invalidProductIdentifiers.count != 1) {
//        [self.logger info:@""]
        [[[TikTok getInstance] logger] info:@"TikTokPaymentObserver: Expect to resolve one product per request"];
    }
    SKProduct *product = nil;
    if (products.count) {
        product = [products objectAtIndex:0];
    }
    [self logTransactionEvent:product];
}

- (void)requestDidFinish:(SKRequest *)request
{
    [self cleanUp];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [self logTransactionEvent:nil];
    [self cleanUp];
}

- (void)cleanUp
{
    @synchronized (g_pendingRequestors) {
        [g_pendingRequestors removeObject:self];
    }
}

//- (void)trackAutomaticSubscribeEvent:(SKPaymentTransaction *)transaction ofProduct:(SKProduct *)product
//{
//    NSString *eventName = nil;
//    NSString *originalTransactionId = transaction.originalTransaction.transactionIdentifier;
//    switch (transaction.transactionState) {
//        case SKPaymentTransactionStatePurchasing:
//            eventName = @"SubscribeInitiatedCheckout";
//            break;
//        case SKPaymentTransactionStatePurchased:
//            if ([self isStartTrial:transaction ofProduct:product]) {
//                eventName = @"StartTrial";
//                [self clearOriginalTransactionId:originalTransactionId];
//            } else {
//                if (originalTransactionId && [_originalTransactionSet containsObject:originalTransactionId]) {
//                    return;
//                }
//                eventName = @"Subscribe";
//                [self appendOriginalTransactionId:(originalTransactionId ? : transaction.transactionIdentifier)];
//            }
//            break;
//        case SKPaymentTransactionStateFailed:
//            eventName = @"SubscribeFailed";
//            break;
//        case SKPaymentTransactionStateRestored:
//            eventName = @"SubscribeRestored";
//            break;
//        case SKPaymentTransactionStateDeferred:
//            return;
//    }
//
//    double totalAmount = 0;
//    if(product) {
//        totalAmount = transaction.payment.quantity * product.price.doubleValue;
//    }
//
//    // TODO: This is where we need to call track method from TikTok class. But not sure what the event parameters will be
//    [self logImplicitTransactionEvent:eventName valueToSum:totalAmount parameters:[self getEventParametersOfProduct:product withTransaction:transaction]];
//}

- (void)trackAutomaticPurchaseEvent:(SKPaymentTransaction *)transaction ofProduct:(SKProduct *)product
{
    NSString *eventName = nil;
    switch (transaction.transactionState) {
        case SKPaymentTransactionStatePurchasing:
//            eventName = @"InitiatedCheckout";
            break;
        case SKPaymentTransactionStatePurchased:
            eventName = @"Purchase";
            break;
        case SKPaymentTransactionStateFailed:
//            eventName = @"PurchaseFailed";
            break;
        case SKPaymentTransactionStateRestored:
//            eventName = @"PurchaseRestored";
            break;
        case SKPaymentTransactionStateDeferred:
            break;
    }
    
    double totalAmount = 0;
    if(product){
        totalAmount = transaction.payment.quantity * product.price.doubleValue;
    }
    
    // TODO: Track Event here but not sure what the event parameters will be just as above
    [self logImplicitTransactionEvent:eventName valueToSum:totalAmount parameters:[self getEventParametersOfProduct:product withTransaction:transaction]];
}

- (void)logImplicitTransactionEvent: (NSString *)eventName valueToSum:(double)valueToSum parameters: (NSDictionary<NSString *, id>*)parameters
{
    NSMutableDictionary *eventParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
//    if([_eventsWithReceipt containsObject:eventName]) {
//        NSData *receipt = [self fetchDeviceReceipt];
//        if(receipt){
//            NSString *base64encodedReceipt = [receipt base64EncodedStringWithOptions:0];
//            [eventParameters setObject:base64encodedReceipt forKey:@"receipt_data"];
//        }
//    }
    
//    [eventParameters setObject:@"1" forKey:@"automatic_logged_purchase"];
    [eventParameters setObject:[[NSNumber numberWithDouble:valueToSum] stringValue] forKey:@"value"];
    
    [[TikTok getInstance] trackPurchase:eventName withProperties:eventParameters];
}

- (NSData *)fetchDeviceReceipt
{
    NSURL *receiptURL = [NSBundle bundleForClass:[self class]].appStoreReceiptURL;
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    return receipt;
}

@end
