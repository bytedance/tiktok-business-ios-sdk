//
//  TikTok.m
//  TikTokBusinessSDK
//
//  Created by Aditya Khandelwal on 9/8/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "TikTok.h"
#import "TikTokLogger.h"

@interface TikTok()

@property (nonatomic, assign) BOOL testEnvironment;

@end

@implementation TikTok

-(instancetype)initDuringTest:(BOOL)testEnvironment
{
    self = [super init];
    
    if(self)
    {
        self.testEnvironment = testEnvironment;
        NSLog(@"TikTok SDK initialized");
    }
    
    return self;
}

@end
