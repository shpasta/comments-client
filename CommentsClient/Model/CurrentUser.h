//
//  CurrentUser.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/5/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUser : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSNumber *userID;

+ (CurrentUser *)currentUser;

@end
