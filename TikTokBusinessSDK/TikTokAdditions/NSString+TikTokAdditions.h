//
//  NSString+TikTokAdditions.h
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/22/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(TikTokAdditions)

//- (NSString *)tiktokMd5;
- (NSString *)tiktokSha1;
- (NSString *)tiktokSha256;
- (NSString *)tiktokTrim;
- (NSString *)tiktokUrlEncode;
- (NSString *)tiktokUrlDecode;
- (NSString *)tiktokRemoveColons;

+ (NSString *)tiktokJoin: (NSString *)firstString, ...;
+ (BOOL)tiktokIsEqual: (NSString *)first toString: (NSString *)second;

@end

NS_ASSUME_NONNULL_END
