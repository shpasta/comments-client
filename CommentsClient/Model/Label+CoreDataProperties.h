//
//  Label+CoreDataProperties.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/8/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Label.h"

NS_ASSUME_NONNULL_BEGIN

@interface Label (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *labelID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) PullRequest *pullRequest;

@end

NS_ASSUME_NONNULL_END
