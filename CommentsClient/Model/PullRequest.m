//
//  PullRequest.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/5/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "PullRequest.h"
#import "SessionManager.h"
#import "Store.h"
#import "User.h"
#import "CurrentUser.h"

#import <MagicalRecord/MagicalRecord.h>

@implementation PullRequest

+ (void)getPullRequests:(void(^ __nullable)(id result, NSError *error))completion {
    [[SessionManager sharedManager] getPullRequests:^(id result, NSError *error){
        if (!error) {
            [[Store sharedStore] performBackgroundOperationWithBlock:^{
                 __unused NSArray *pullRequestArray = [PullRequest MR_importFromArray:result inContext:[Store sharedStore].currentBackgroundContext];
                
                // Delete entities that was not included in response
                NSArray *idList = [result valueForKey:@"id"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(pullRequestID IN %@)", idList];
                [PullRequest MR_deleteAllMatchingPredicate:predicate inContext:[Store sharedStore].currentBackgroundContext];
            }];
        }
        if (completion)
            completion(result, error);
    }];
}

//- (BOOL)isOwned {
//    return [self.user.userID isEqual:[CurrentUser currentUser].userID];
//}

// MVVM
- (NSString *)createdAtString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm a, MM/dd/yyyy"];
    return [formatter stringFromDate:self.createdAt];
}

@end
