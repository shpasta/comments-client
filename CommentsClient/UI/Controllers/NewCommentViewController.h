//
//  NewCommentViewController.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/6/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullRequest;

@interface NewCommentViewController : UIViewController

- (instancetype)initWithPullRequest:(PullRequest *)pullRequest;

@end
