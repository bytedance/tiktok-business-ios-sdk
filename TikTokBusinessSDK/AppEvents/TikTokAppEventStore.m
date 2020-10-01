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

#define MAX_NUMBER_EVENTS_IN_DISK 10000

// Optimization to skip check if we know there are no persisted events
static BOOL canSkipDiskCheck = NO;
// Total number of events dumped as a result of exceeding max number of events in disk
static long numberOfEventsDumped = 0;

@implementation TikTokAppEventStore


+ (void)clearPersistedAppEvents {
    [[NSFileManager defaultManager] removeItemAtPath:[[self class] getFilePath]
                                               error:NULL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"inDiskEventQueueUpdated" object:nil];
    canSkipDiskCheck = YES;
}

+ (void)persistAppEvents:(NSArray *)queue {
    if (!queue.count) {
        return;
    }
    NSMutableArray *existingEvents = [NSMutableArray arrayWithArray:[[self class] retrievePersistedAppEvents]];
    [[self class] clearPersistedAppEvents];
    [existingEvents addObjectsFromArray:queue];
    
    // if number of events to store is greater than MAX_NUMBER_EVENTS_IN_DISK, store the later events with length of MAX_NUMBER_EVENTS_IN_DISK
    if(existingEvents.count > MAX_NUMBER_EVENTS_IN_DISK) {
        long difference = existingEvents.count - MAX_NUMBER_EVENTS_IN_DISK;
        numberOfEventsDumped += difference;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"eventsDumped" object:nil userInfo:@{@"numberOfEventsDumped":@(numberOfEventsDumped)}];
        NSArray *existingEventsSliced = [existingEvents subarrayWithRange:NSMakeRange(difference, MAX_NUMBER_EVENTS_IN_DISK)];
        // converts back to NSMutableArray type
        existingEvents = [existingEventsSliced mutableCopy];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        NSError *errorArchiving = nil;
        // archivedDataWithRootObject:requiringSecureCoding: available iOS 11.0+
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:existingEvents requiringSecureCoding:NO error:&errorArchiving];
        [data writeToFile:[[self class] getFilePath] atomically:YES];
    } else {
        // archiveRootObject used for iOS versions below 11.0
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [NSKeyedArchiver archiveRootObject:existingEvents toFile:[[self class] getFilePath]];
#pragma clang diagnostic pop
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [events addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] getFilePath]]];
#pragma clang diagnostic pop
        }
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
