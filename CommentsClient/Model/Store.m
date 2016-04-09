//
//  Store.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/7/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "Store.h"

@interface Store ()
@property (nonatomic, strong, readwrite) NSOperationQueue *backgroundQueue;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *currentBackgroundContext;
@end

@implementation Store

+ (Store *)sharedStore {
    static Store *_store = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _store = [[Store alloc] init];
    });
    return _store;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundQueue = [[NSOperationQueue alloc] init];
        _backgroundQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)performBackgroundOperationWithBlock:(void (^)(void))block {
    [self.backgroundQueue addOperationWithBlock:^{
        // Create independent background context in background thread
        self.currentBackgroundContext = [NSManagedObjectContext MR_newPrivateQueueContext];
        self.currentBackgroundContext.persistentStoreCoordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
        
        // Perform block synchronously in current background thread
        [self.currentBackgroundContext performBlockAndWait:block];
        
        // Save changes to persistent store synchronously in current background thread
        [self.currentBackgroundContext MR_saveToPersistentStoreAndWait];
        
        // Current background context can be used only in current operation
        self.currentBackgroundContext = nil;
    }];
}

@end
