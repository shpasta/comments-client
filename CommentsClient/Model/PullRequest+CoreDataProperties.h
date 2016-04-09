//
//  PullRequest+CoreDataProperties.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/8/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PullRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class Comment, User, Label;

@interface PullRequest (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *issueUrl;
@property (nullable, nonatomic, retain) NSNumber *number;
@property (nullable, nonatomic, retain) NSNumber *pullRequestID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSSet<Comment *> *comment;
@property (nullable, nonatomic, retain) User *user;
@property (nullable, nonatomic, retain) Label *label;

@end

@interface PullRequest (CoreDataGeneratedAccessors)

- (void)addCommentObject:(Comment *)value;
- (void)removeCommentObject:(Comment *)value;
- (void)addComment:(NSSet<Comment *> *)values;
- (void)removeComment:(NSSet<Comment *> *)values;

@end

NS_ASSUME_NONNULL_END
