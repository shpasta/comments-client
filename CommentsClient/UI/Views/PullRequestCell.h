//
//  PullRequestCell.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/4/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullRequest;

@interface PullRequestCell : UITableViewCell

- (void)setupPullRequest:(PullRequest *)pullRequest;

@end
