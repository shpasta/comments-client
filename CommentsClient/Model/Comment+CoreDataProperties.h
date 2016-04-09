//
//  Comment+CoreDataProperties.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/7/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@class User;

@interface Comment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *commentID;
@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) PullRequest *pullRequest;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
