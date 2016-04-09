//
//  User+CoreDataProperties.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/7/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@class PullRequest, Comment;

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) NSString *login;
@property (nullable, nonatomic, retain) NSSet<Comment *> *comment;
@property (nullable, nonatomic, retain) NSSet<PullRequest *> *pullRequest;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCommentObject:(Comment *)value;
- (void)removeCommentObject:(Comment *)value;
- (void)addComment:(NSSet<Comment *> *)values;
- (void)removeComment:(NSSet<Comment *> *)values;

- (void)addPullRequestObject:(PullRequest *)value;
- (void)removePullRequestObject:(PullRequest *)value;
- (void)addPullRequest:(NSSet<PullRequest *> *)values;
- (void)removePullRequest:(NSSet<PullRequest *> *)values;

@end

NS_ASSUME_NONNULL_END
