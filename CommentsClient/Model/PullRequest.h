//
//  PullRequest.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/5/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface PullRequest : NSManagedObject

+ (void)getPullRequests:(void(^ __nullable)(id result, NSError *error))completion;

//- (BOOL)isOwned;

- (NSString *)createdAtString;

@end

NS_ASSUME_NONNULL_END

#import "PullRequest+CoreDataProperties.h"
