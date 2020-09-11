//
//  TikTokAppEventStore.h
//  TikTokBusinessSDK
//
//  Created by Christopher Yang on 9/4/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class TikTokEventQueue;

@interface TikTokAppEventStore : NSObject

/**
 * @brief Method to clear persisted app events
 */
+ (void)clearPersistedAppEvents;

/**
 * @brief Method to read events in disk, append events in queue, and write combined into disk
 */
+ (void)persistAppEventsData:(TikTokEventQueue *)queue;

/**
 * @brief Method to return the array of saved app event states and deletes them.
 */
+ (NSArray *)retrievePersistedAppEvents;

@end

NS_ASSUME_NONNULL_END
