//
// Copyright (c) 2020. Bytedance Inc.
//
// This source code is licensed under the MIT license found in
// the LICENSE file in the root directory of this source tree.
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
