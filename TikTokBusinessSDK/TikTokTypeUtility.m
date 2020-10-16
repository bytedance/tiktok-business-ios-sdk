//
//  TikTokTypeUtility.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 10/16/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTokTypeUtility.h"
#import "TikTokErrorHandler.h"

@implementation TikTokTypeUtility

+ (NSData *)dataWithJSONObject:(id)obj
                       options:(NSJSONWritingOptions)opt
                         error:(NSError *__autoreleasing  _Nullable *)error
                        origin:(NSString *)origin
{
  NSData *data;

  @try {
    data = [NSJSONSerialization dataWithJSONObject:obj options:opt error:error];
  } @catch (NSException *exception) {
      [TikTokErrorHandler handleErrorWithOrigin:origin message:@"JSONSerialization dataWithJSONObject:options:error failure" exception:exception];
  }
  return data;
}

+ (id)JSONObjectWithData:(NSData *)data
                 options:(NSJSONReadingOptions)opt
                   error:(NSError *__autoreleasing  _Nullable *)error
                  origin:(NSString *)origin
{
  if (![data isKindOfClass:NSData.class]) {
    return nil;
  }

  id object;
  @try {
     object = [NSJSONSerialization JSONObjectWithData:data options:opt error:error];
  } @catch (NSException *exception) {
      [TikTokErrorHandler handleErrorWithOrigin:origin message:@"JSONSerialization JSONObjectWithData:options:error failure" exception:exception];
  }
  return object;
}

@end
