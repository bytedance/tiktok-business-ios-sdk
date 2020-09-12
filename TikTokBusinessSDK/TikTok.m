//
//  TikTok.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTok.h"

@implementation TikTok

-(instancetype)initDuringTest
{
    self = [super init];
    
    if(self)
    {
        NSLog(@"TikTok SDK has been initialized");
    }
    
    return self;
    
    
}

@end
