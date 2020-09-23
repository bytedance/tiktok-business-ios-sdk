//
//  NSString+TikTokAdditions.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/22/20.
//  Copyright © 2020 bytedance. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "NSString+TikTokAdditions.h"

@implementation NSString(TikTokAdditions)

- (NSString *)tiktokTrim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)tiktokUrlEncode
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "]];
}

- (NSString *)tiktokUrlDecode
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, CFSTR("")));
}

- (NSString *)tiktokRemoveColons
{
    return [self stringByReplacingOccurrencesOfString:@":" withString:@""];
}

- (NSString *)tiktokSha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString *)tiktokSha256
{
    const char* str = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+ (NSString *)tiktokJoin:(NSString *)firstString, ...
{
    NSString *iter, *result = firstString;
    va_list strings;
    va_start(strings, firstString);

    while ((iter = va_arg(strings, NSString*))) {
        NSString *capitalized = iter.capitalizedString;
        result = [result stringByAppendingString:capitalized];
    }
    
    va_end(strings);
    return result;
}

+ (BOOL)tiktokIsEqual:(NSString *)first toString:(NSString *)second
{
    if (first == nil && second == nil) {
        return YES;
    }
    
    return [first isEqualToString:second];
}

@end
