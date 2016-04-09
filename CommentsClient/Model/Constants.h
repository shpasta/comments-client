//
//  Constants.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/8/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#warning Hardcoded data

// test-user-01, test-user-02
#define UserIDs ( @[@18272041, @18358890] )
#define UserAccessTokens ( @[@"d09b650f789c5e9479deab18560f841fa07a0f0a", @"b8c493963a5482f5e08639a34bbfb683baf297a9"] )

// URLs, test-user-02 is owner
#define baseURL         ( @"https://api.github.com" )
#define pullRequestAPI  ( @"repos/test-user-02/test-repo/pulls" )
#define issuesAPI       ( @"repos/test-user-02/test-repo/issues" )


// Predefined label for pull request
#define LabelTitle ( @"+1" )


#endif /* Constants_h */
