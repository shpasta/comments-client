//
//  SessionManager.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/4/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "SessionManager.h"
#import "CurrentUser.h"
#import "PullRequest.h"
#import "Comment.h"
#import "Label.h"
#import "Constants.h"
#import "AFNetworkActivityIndicatorManager.h"


@implementation SessionManager

+ (SessionManager*)sharedManager {
    static SessionManager *_sessioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessioManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
    return _sessioManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (void)getPullRequests:(void(^)(id result, NSError *error))completion {
    NSDictionary *params = @{@"access_token": [CurrentUser currentUser].accessToken};
    [self GET:pullRequestAPI parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        if (completion)
            completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        if (completion)
            completion(nil, error);
    }];
}

- (void)getCommentsForPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/comments", issuesAPI, pullRequest.number];
    NSDictionary *params = @{@"access_token": [CurrentUser currentUser].accessToken};
    [self GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        if (completion)
            completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        if (completion)
            completion(nil, error);
    }];
}

- (void)postComment:(NSString *)comment forPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/comments?access_token=%@", issuesAPI, pullRequest.number, [CurrentUser currentUser].accessToken];
    NSDictionary *params = @{@"body": comment};
    
    [self POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        if (completion)
            completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        if (completion)
            completion(nil, error);
    }];
}

- (void)getLabelsForPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/labels", issuesAPI, pullRequest.number];
    NSDictionary *params = @{@"access_token": [CurrentUser currentUser].accessToken};
    [self GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        if (completion)
            completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        if (completion)
            completion(nil, error);
    }];
}

- (void)postLabelForPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/labels?access_token=%@", issuesAPI, pullRequest.number, [CurrentUser currentUser].accessToken];
    NSArray *params = @[@"+1"];
    
    [self POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        if (completion)
            completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        if (completion)
            completion(nil, error);
    }];
}

- (void)deleteLabelForPullRequest:(PullRequest *)pullRequest completion:(void(^)(id result, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/labels/%@?access_token=%@", issuesAPI, pullRequest.number, pullRequest.label.name , [CurrentUser currentUser].accessToken];
    
    [self DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        if (completion)
            completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        if (completion)
            completion(nil, error);
    }];
}

- (BOOL)isConnectionAvailable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

@end
