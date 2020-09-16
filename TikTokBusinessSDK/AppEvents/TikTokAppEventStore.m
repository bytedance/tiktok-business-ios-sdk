//
//  TikTokAppEventStore.m
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

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

+ (void)persistAppEventsData:(TikTokAppEventQueue *)queue {
    // TODO: Implement logging
    if (!queue.eventQueue.count) {
        return;
    }
    NSMutableArray *existingEvents = [NSMutableArray arrayWithArray:[[self class] retrievePersistedAppEvents]];
    
    [existingEvents addObjectsFromArray:queue.eventQueue];
    
    // TODO: implement condition for iOS 11 and add logic below
    // [NSKeyedArchiver archiveRootObject:existingEvents toFile:[[self class] getFilePath]];
    
    // solution for iOS 12 and above
    NSError *errorArchiving = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:existingEvents requiringSecureCoding:NO error:&errorArchiving];
    [data writeToFile:[[self class] getFilePath] atomically:YES];
    canSkipDiskCheck = NO;
}

+ (NSArray *)retrievePersistedAppEvents {
    NSMutableArray *events = [NSMutableArray array];
    if (!canSkipDiskCheck) {
        // TODO: implement condition for iOS 11 and add logic below
        // [eventsStates addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] getfilePath]]];
        
        // solution for iOS 12 and above
        NSData *data = [NSData dataWithContentsOfFile:[[self class] getFilePath]];
        NSError *errorUnarchiving = nil;
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&errorUnarchiving];
        [unarchiver setRequiresSecureCoding:NO];
        [events addObjectsFromArray:[unarchiver decodeObjectOfClass:[NSArray class] forKey:NSKeyedArchiveRootObjectKey]];
        
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
