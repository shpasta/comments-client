//
//  CommentsViewController.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/5/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullRequest;

@interface CommentsViewController : UIViewController

- (instancetype)initWithPullRequest:(PullRequest *)pullRequest;

@end
