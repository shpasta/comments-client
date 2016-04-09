//
//  Label.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/8/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PullRequest;

NS_ASSUME_NONNULL_BEGIN

@interface Label : NSManagedObject

+ (void)getLabelsForPullRequest:(PullRequest *)pullRequest completion:(void(^ __nullable)(id result, NSError *error))completion;
+ (void)postLabelForPullRequest:(PullRequest *)pullRequest completion:(void(^ __nullable)(id result, NSError *error))completion;
+ (void)deleteLabelForPullRequest:(PullRequest *)pullRequest completion:(void(^ __nullable)(id result, NSError *error))completion;

+ (BOOL)isLabelAvailable;

@end

NS_ASSUME_NONNULL_END

#import "Label+CoreDataProperties.h"
