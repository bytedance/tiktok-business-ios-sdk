//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
//

#import "TikTokSKAdNetworkSupport.h"
#import "TikTokSKAdNetworkConversionConfiguration.h"

@interface TikTokSKAdNetworkSupport()

@property (nonatomic, strong, readwrite) Class skAdNetworkClass;
@property (nonatomic, assign, readwrite) SEL skAdNetworkRegisterAppForAdNetworkAttribution;
@property (nonatomic, assign, readwrite) SEL skAdNetworkUpdateConversionValue;

@end


@implementation TikTokSKAdNetworkSupport

+ (TikTokSKAdNetworkSupport *)sharedInstance
{
    static TikTokSKAdNetworkSupport *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[TikTokSKAdNetworkSupport alloc]init];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentConversionValue = 0;
        self.skAdNetworkClass = NSClassFromString(@"SKAdNetwork");
        self.skAdNetworkRegisterAppForAdNetworkAttribution = NSSelectorFromString(@"registerAppForAdNetworkAttribution");
        self.skAdNetworkUpdateConversionValue = NSSelectorFromString(@"updateConversionValue");
    }
    return self;
}

- (void)registerAppForAdNetworkAttribution
{
    if (@available(iOS 14.0, *)) {
        ((id (*)(id, SEL))[self.skAdNetworkClass methodForSelector:self.skAdNetworkRegisterAppForAdNetworkAttribution])(self.skAdNetworkClass, self.skAdNetworkRegisterAppForAdNetworkAttribution);
    }
}

-(void)updateConversionValue:(NSInteger)conversionValue
{
    // Equivalent call: [SKAdNetwork updateConversionValue:conversionValue]
    if (@available(iOS 14.0, *)) {
        ((id (*)(id, SEL, NSInteger))[self.skAdNetworkClass methodForSelector:self.skAdNetworkUpdateConversionValue])(self.skAdNetworkClass, self.skAdNetworkUpdateConversionValue, conversionValue);
    }
}

- (void)matchEventToSKANConfig:(NSString *)eventName withValue:(nullable NSString *)value
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *eventValue = [formatter numberFromString:value];
    NSLog(@"EVENT VALUE: %@", eventValue);
    NSMutableArray *rules = [TikTokSKAdNetworkConversionConfiguration sharedInstance].conversionValueRules;
    for(TikTokSKAdNetworkRule *rule in rules){
        if((NSInteger)rule.conversionValue > _currentConversionValue){
            if([eventName isEqual:rule.eventName] && eventValue >= rule.minRevenue && eventValue <= rule.maxRevenue){
                NSLog(@"Prev conversion value: %ld", _currentConversionValue);
                _currentConversionValue = (NSInteger)rule.conversionValue;
                NSLog(@"New conversion value: %ld", _currentConversionValue);
                break;
            }
        }
    }
    
}

@end
