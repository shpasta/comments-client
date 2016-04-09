//
//  Comment+CoreDataProperties.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/7/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Comment+CoreDataProperties.h"

@implementation Comment (CoreDataProperties)

@dynamic commentID;
@dynamic body;
@dynamic url;
@dynamic createdAt;
@dynamic pullRequest;
@dynamic user;

@end
