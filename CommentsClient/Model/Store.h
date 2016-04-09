//
//  Store.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/7/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>

@interface Store : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *currentBackgroundContext;

- (void)performBackgroundOperationWithBlock:(void (^)(void))block;

+ (Store *)sharedStore;

@end
