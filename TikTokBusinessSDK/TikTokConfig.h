//
//  TikTokConfig.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TikTokLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface TikTokConfig : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *accessToken;
@property (nonatomic, copy, readonly, nonnull) NSString *appID;
@property (nonatomic, readonly) BOOL isSuppressed;

@property (nonatomic, assign) TikTokLogLevel logLevel;

@property (nonatomic, assign) BOOL trackingEnabled;
@property (nonatomic, assign) BOOL automaticLoggingEnabled;
@property (nonatomic, assign) BOOL installLoggingEnabled;
@property (nonatomic, assign) BOOL launchLoggingEnabled;
@property (nonatomic, assign) BOOL retentionLoggingEnabled;
@property (nonatomic, assign) BOOL paymentLoggingEnabled;

+ (nullable TikTokConfig *)configWithAccessToken:(nonnull NSString *)accessToken
                                        appID:(nonnull NSString *)appID
                    suppressAppTrackingDialog: (BOOL)isSuppressed;

//+ (void)disableTracking;
- (void)disableTracking;

//+ (void)disableAutomaticLogging;
- (void)disableAutomaticLogging;

//+ (void)disableInstallLogging;
- (void)disableInstallLogging;

//+ (void)disableLaunchLogging;
- (void)disableLaunchLogging;

//+ (void)disableRetentionLogging;
- (void)disableRetentionLogging;

//+ (void)disablePaymentLogging;
- (void)disablePaymentLogging;

- (nullable id)initWithAccessToken:(nonnull NSString *)accessToken
                          appID:(nonnull NSString *)appID
                suppressAppTrackingDialog: (BOOL)isSuppressed;

@end

NS_ASSUME_NONNULL_END
