//
//  TikTokAppEventStore.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TikTokAppEventStore.h"
#import "TikTokAppEventQueue.h"

// Optimization to skip check if we know there are no persisted events
static BOOL canSkipDiskCheck = NO;

@implementation TikTokAppEventStore

+ (void)clearPersistedAppEvents {
    // TODO: Implement logging
    [[NSFileManager defaultManager] removeItemAtPath:[[self class] getFilePath]
                                               error:NULL];
    canSkipDiskCheck = YES;
}

+ (void)persistAppEvents:(TikTokAppEventQueue *)queue {
    // TODO: Implement logging
    if (!queue.eventQueue.count) {
        return;
    }
    NSMutableArray *existingEvents = [NSMutableArray arrayWithArray:[[self class] retrievePersistedAppEvents]];
    
    [existingEvents addObjectsFromArray:queue.eventQueue];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        NSError *errorArchiving = nil;
        // archivedDataWithRootObject:requiringSecureCoding: available iOS 11.0+
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:existingEvents requiringSecureCoding:NO error:&errorArchiving];
        [data writeToFile:[[self class] getFilePath] atomically:YES];
    } else {
        // archiveRootObject used for iOS versions below 11.0
        [NSKeyedArchiver archiveRootObject:existingEvents toFile:[[self class] getFilePath]];
    }
    
    canSkipDiskCheck = NO;
}

+ (NSArray *)retrievePersistedAppEvents {
    NSMutableArray *events = [NSMutableArray array];
    if (!canSkipDiskCheck) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
            NSData *data = [NSData dataWithContentsOfFile:[[self class] getFilePath]];
            NSError *errorUnarchiving = nil;
            // initForReadingFromData:error: available iOS 11.0+
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&errorUnarchiving];
            [unarchiver setRequiresSecureCoding:NO];
            [events addObjectsFromArray:[unarchiver decodeObjectOfClass:[NSArray class] forKey:NSKeyedArchiveRootObjectKey]];
        } else {
            // unarchiveObjectWithFile used for iOS versions below 11.0
            [events addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] getFilePath]]];
        }
        
        // TODO: Implement logging
        
        [[self class] clearPersistedAppEvents];
    }
    return events;
}

#pragma mark - Private Helpers

+ (NSString *)getFilePath {
    NSSearchPathDirectory directory = NSLibraryDirectory;
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    return [docDirectory stringByAppendingPathComponent:@"com-tiktok-sdk-AppEventsPersistedEvents.json"];
}

@end
