//
//  Comment.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/5/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PullRequest;

NS_ASSUME_NONNULL_BEGIN

@interface Comment : NSManagedObject

+ (void)getCommentsForPullRequest:(PullRequest *)pullRequest completion:(void(^ __nullable)(id result, NSError *error))completion;
+ (void)postComment:(NSString *)comment forPullRequest:(PullRequest *)pullRequest completion:(void(^ __nullable)(id result, NSError *error))completion;

- (BOOL)isOwned;

- (NSString *)createdAtString;

@end

NS_ASSUME_NONNULL_END

#import "Comment+CoreDataProperties.h"
