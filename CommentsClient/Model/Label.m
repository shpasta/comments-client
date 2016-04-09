//
//  Label.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/8/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "Label.h"
#import "PullRequest.h"
#import "User.h"
#import "CurrentUser.h"
#import "SessionManager.h"
#import "Store.h"
#import "Constants.h"


@implementation Label

+ (void)getLabelsForPullRequest:(PullRequest *)pullRequest completion:(void(^ __nullable)(id result, NSError *error))completion {
    [[SessionManager sharedManager] getLabelsForPullRequest:pullRequest completion:^(id result, NSError *error) {
        if (!error) {
            [[Store sharedStore] performBackgroundOperationWithBlock:^{
                // We manage only on type of label "+1", filter response by this type
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", LabelTitle];
                NSArray *labelArray = [result filteredArrayUsingPredicate:predicate];

                // Label ID is not included in response, and we should make relation to PullRequest manually
                PullRequest *localPullRequest = [PullRequest MR_findFirstByAttribute:@"pullRequestID" withValue:pullRequest.pullRequestID inContext:[Store sharedStore].currentBackgroundContext];
                if (labelArray.count > 0) {
                    NSDictionary *labelDictionary = labelArray.firstObject;
                    Label *label = [Label MR_importFromObject:labelDictionary inContext:[Store sharedStore].currentBackgroundContext];
                    
                    if (localPullRequest.label) {
                        localPullRequest.label.name = label.name;
                        localPullRequest.label.url = label.url;
                    } else {
                        localPullRequest.label = label;
                    }
                    
                } else {
                    // Delete old local label
                    predicate = [NSPredicate predicateWithFormat:@"pullRequest.pullRequestID == %@", pullRequest.pullRequestID];
                    [Label MR_deleteAllMatchingPredicate:predicate inContext:[Store sharedStore].currentBackgroundContext];
                    localPullRequest.label = nil;
                }
            }];
        }
        if (completion)
            completion(result, error);
    }];
}

+ (void)postLabelForPullRequest:(PullRequest *)pullRequest completion:(void(^ __nullable)(id result, NSError *error))completion {
    [[SessionManager sharedManager] postLabelForPullRequest:pullRequest completion:^(id result, NSError *error) {
        if (!error) {
            [[Store sharedStore] performBackgroundOperationWithBlock:^{
                // We manage only one type of label "+1"; filter response by this type
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", LabelTitle];
                NSArray *labelArray = [result filteredArrayUsingPredicate:predicate];
                
                // Delete old local label
                predicate = [NSPredicate predicateWithFormat:@"pullRequest.pullRequestID == %@", pullRequest.pullRequestID];
                [Label MR_deleteAllMatchingPredicate:predicate inContext:[Store sharedStore].currentBackgroundContext];
                
                // Label ID is not included in response, and we should make relation to PullRequest manually
                PullRequest *localPullRequest = [PullRequest MR_findFirstByAttribute:@"pullRequestID" withValue:pullRequest.pullRequestID inContext:[Store sharedStore].currentBackgroundContext];
                if (labelArray.count > 0) {
                    NSDictionary *labelDictionary = labelArray.firstObject;
                    Label *label = [Label MR_importFromObject:labelDictionary inContext:[Store sharedStore].currentBackgroundContext];
                    localPullRequest.label = label;
                }
            }];
        }
        if (completion)
            completion(result, error);
    }];
}

+ (void)deleteLabelForPullRequest:(PullRequest *)pullRequest completion:(void(^ __nullable)(id result, NSError *error))completion {
    [[SessionManager sharedManager] deleteLabelForPullRequest:pullRequest completion:^(id result, NSError *error) {
        if (!error) {
            [[Store sharedStore] performBackgroundOperationWithBlock:^{
                // Delete old local label
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pullRequest.pullRequestID == %@", pullRequest.pullRequestID];
                [Label MR_deleteAllMatchingPredicate:predicate inContext:[Store sharedStore].currentBackgroundContext];
            }];
        }
        if (completion)
            completion(result, error);
    }];
}

#warning Hardcoded data

+ (BOOL)isLabelAvailable {
    return ([[CurrentUser currentUser].userID isEqual:UserIDs[1]]);
}

@end
