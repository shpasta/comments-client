//
//  PullRequest+CoreDataProperties.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/8/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PullRequest+CoreDataProperties.h"

@implementation PullRequest (CoreDataProperties)

@dynamic body;
@dynamic createdAt;
@dynamic issueUrl;
@dynamic number;
@dynamic pullRequestID;
@dynamic title;
@dynamic url;
@dynamic comment;
@dynamic user;
@dynamic label;

@end
