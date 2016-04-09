//
//  CurrentUser.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/5/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "CurrentUser.h"
#import "Constants.h"

@implementation CurrentUser

static NSString *kAccessTokenKey = @"keychain_token_key";
static NSString *kUserIDKey = @"keychain_user_id_key";

+ (CurrentUser *)currentUser {
    static CurrentUser *_currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentUser = [[self alloc] init];
    });
    return _currentUser;
}

- (void)setAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)accessToken {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessTokenKey];
    if (accessToken == nil) {
        accessToken = UserAccessTokens.firstObject;
        self.accessToken = accessToken;
    }
    return accessToken;
}

- (void)setUserID:(NSNumber *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kUserIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)userID {
    NSNumber *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserIDKey];
    if (userID == nil) {
        userID = UserIDs.firstObject;
        self.userID = userID;
    }
    return userID;
}

@end
