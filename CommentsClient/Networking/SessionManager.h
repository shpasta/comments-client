//
//  SessionManager.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/4/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

@class PullRequest, Comment;

@interface SessionManager : AFHTTPSessionManager

+ (SessionManager*)sharedManager;


- (void)getPullRequests:(void(^)(id result, NSError *error))completion;

- (void)getCommentsForPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion;
- (void)postComment:(NSString *)comment forPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion;

- (void)getLabelsForPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion;
- (void)postLabelForPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion;
- (void)deleteLabelForPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion;

- (BOOL)isConnectionAvailable;

@end
